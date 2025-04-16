from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework import status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.contrib.auth.models import User
from django.db import transaction
from django.conf import settings
from django.core.validators import validate_email
from django.core.exceptions import ValidationError
from django.shortcuts import get_object_or_404
from .models import Profile, Transaction
from .serializers import ProfileSerializer  # You'll need to create this
from django.db.models import Q
import logging
from rest_framework_simplejwt.views import TokenRefreshView

class CustomTokenRefreshView(TokenRefreshView):
    """
    Custom view to refresh JWT tokens.
    """
    pass  # Uses default behavior
class CustomTokenObtainPairView(TokenObtainPairView):
    """Custom login view to get JWT tokens."""
    pass  # Uses default behavior

logger = logging.getLogger(__name__)

class RegisterAPIView(APIView):
    """
    API view for user registration with profile creation
    """
    permission_classes = [AllowAny]
    
    def post(self, request):
        """
        Handle POST requests for user registration
        """
        try:
            # Extract data from request
            username = request.data.get('username')
            password = request.data.get('password')
            email = request.data.get('email')
            name = request.data.get('name')
            phone = request.data.get('phone')
            app_pin = request.data.get('app_pin')
            borrow_pin = request.data.get('borrow_pin')
            image = request.data.get('image')
            
            # Validate required fields
            if not all([username, password, email, name]):
                return Response(
                    {'error': 'Missing required fields'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Validate username
            if User.objects.filter(username=username).exists():
                return Response(
                    {'error': 'Username already exists'}, 
                    status=status.HTTP_409_CONFLICT
                )
            
            # Validate email format
            try:
                validate_email(email)
            except ValidationError:
                return Response(
                    {'error': 'Invalid email format'},
                    status=status.HTTP_400_BAD_REQUEST
                )
                
            # Check if email already exists
            if User.objects.filter(email=email).exists():
                return Response(
                    {'error': 'Email already registered'},
                    status=status.HTTP_409_CONFLICT
                )
            
            # Validate PIN formats if provided
            if app_pin and (not str(app_pin).isdigit() or len(str(app_pin)) != 4):
                return Response(
                    {'error': 'App PIN must be a 4-digit number'},
                    status=status.HTTP_400_BAD_REQUEST
                )
                
            if borrow_pin and (not str(borrow_pin).isdigit() or len(str(borrow_pin)) != 4):
                return Response(
                    {'error': 'Borrow PIN must be a 4-digit number'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Validate password strength
            if len(password) < 8:
                return Response(
                    {'error': 'Password must be at least 8 characters'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Use transaction to ensure atomicity
            with transaction.atomic():
                # Create the User
                user = User.objects.create_user(
                    username=username,
                    email=email,
                    password=password
                )
                
                # Create the Profile
                profile_data = {
                    'user': user,
                    'name': name,
                    'email': email,
                    'phone': phone or '',
                    'app_pin': app_pin or 0,
                    'borrow_pin': borrow_pin or 0,
                }
                
                if image:
                    profile_data['image'] = image
                
                profile = Profile.objects.create(**profile_data)
                
                # Serialize the response
                serializer = ProfileSerializer(profile)
                response_data = {
                    'message': 'Registration successful',
                    'user_id': user.id,
                    'profile': serializer.data
                }
                
                return Response(response_data, status=status.HTTP_201_CREATED)
                
        except Exception as e:
            # Log the error for debugging
            logger.error(f"Registration error: {str(e)}")
            
            # Don't expose internal errors to clients
            return Response(
                {'error': 'Registration failed. Please try again later.'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )






class TransactionAPIView(APIView):
    """
    API view to handle money transfers between profiles
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication] 
    
    def post(self, request):
        try:
            # Get data from request
            receiver_id = request.data.get('receiver_id')
            amount = request.data.get('amount')
            app_pin = request.data.get('app_pin')
            note = request.data.get('note', 'No note')
            
            # Validate required fields
            if not all([receiver_id, amount, app_pin]):
                return Response(
                    {'error': 'Missing required fields. Please provide receiver_id, amount, and app_pin.'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Convert amount to integer if possible
            try:
                amount = int(amount)
                if amount <= 0:
                    return Response(
                        {'error': 'Amount must be greater than zero'},
                        status=status.HTTP_400_BAD_REQUEST
                    )
            except (ValueError, TypeError):
                return Response(
                    {'error': 'Amount must be a valid number'},
                    status=status.HTTP_400_BAD_REQUEST
                )
                
            # Get sender profile (from authenticated user)
            try:
                sender = Profile.objects.get(user=request.user)
            except Profile.DoesNotExist:
                return Response(
                    {'error': 'Your profile does not exist'},
                    status=status.HTTP_404_NOT_FOUND
                )
                
            # Verify app PIN
            if int(app_pin) != sender.app_pin:
                return Response(
                    {'error': 'Invalid PIN. Transaction canceled for security reasons.'},
                    status=status.HTTP_401_UNAUTHORIZED
                )
                
            # Get receiver profile
            try:
                receiver = Profile.objects.get(user=receiver_id)
            except Profile.DoesNotExist:
                return Response(
                    {'error': 'Recipient profile not found'},
                    status=status.HTTP_404_NOT_FOUND
                )
                
            # Prevent sending money to self
            if sender.id == receiver.id:
                return Response(
                    {'error': 'Cannot send money to yourself'},
                    status=status.HTTP_400_BAD_REQUEST
                )
                
            # Check if sender has sufficient balance
            if sender.balance < amount:
                return Response(
                    {'error': 'Insufficient balance'},
                    status=status.HTTP_400_BAD_REQUEST
                )
                
            # Execute transaction with database transaction to ensure atomicity
            with transaction.atomic():
                # Create transaction record
                transaction_record = Transaction.objects.create(
                    sender=sender,
                    receiver=receiver,
                    amount=amount,
                    note=note,
                    status='completed'  # Set as completed immediately
                )
                
                # Update balances
                sender.balance -= amount
                receiver.balance += amount
                
                sender.save()
                receiver.save()
                
            # Prepare response data
            response_data = {
                'message': 'Transaction successful',
                'transaction_id': transaction_record.id,
                'sender': sender.name,
                'receiver': receiver.name,
                'amount': amount,
                'date': transaction_record.date,
                'status': transaction_record.status,
                'note': transaction_record.note,
                'new_balance': sender.balance
            }
            
            return Response(response_data, status=status.HTTP_201_CREATED)
                
        except Exception as e:
            # Log the error
            logger.error(f"Transaction error: {str(e)}")
            
            # Generic error response
            return Response(
                {'error': 'Transaction failed. Please try again later.'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
    def get(self, request):
        try:
            # Get query parameters
            transaction_type = request.query_params.get('type', 'all')
            status_filter = request.query_params.get('status', None)
            limit = int(request.query_params.get('limit', 20))
            
            # Get user profile
            profile = get_object_or_404(Profile, user=request.user)
            
            # Base queryset
            queryset = Transaction.objects.filter(Q(sender=profile) | Q(receiver=profile))
            
            # Apply filters
            if transaction_type == 'sent':
                queryset = queryset.filter(sender=profile)
            elif transaction_type == 'received':
                queryset = queryset.filter(receiver=profile)
            else:  # 'all'
                queryset = queryset.filter(sender=profile) | queryset.filter(receiver=profile)
                
            if status_filter:
                queryset = queryset.filter(status=status_filter)
                
            # Order by date (newest first) and limit results
            transactions = queryset.order_by('-date')[:limit]
            
            # Prepare response data
            transaction_data = []
            for t in transactions:
                transaction_data.append({
                    'id': t.id,
                    'sender': t.sender.name,
                    'sender_id': t.sender.id,
                    'receiver': t.receiver.name,
                    'receiver_id': t.receiver.id,
                    'amount': t.amount,
                    'date': t.date,
                    'status': t.status,
                    'note': t.note,
                    'type': 'sent' if t.sender.id == profile.id else 'received'
                })
                
            return Response(transaction_data, status=status.HTTP_200_OK)
                
        except Exception as e:
            logger.error(f"Transaction history error: {str(e)}")
            
            return Response(
                {'error': 'Could not retrieve transaction history.'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class TransactionDetailAPIView(APIView):
    """
    API view to handle operations on a specific transaction
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [TokenAuthentication]
    
    def get(self, request, transaction_id):
        """
        Get details of a specific transaction
        """
        try:
            # Get user profile
            profile = get_object_or_404(Profile, user=request.user)
            
            # Get transaction and verify ownership
            transaction_obj = get_object_or_404(Transaction, id=transaction_id)
            
            # Check if user is part of this transaction
            if transaction_obj.sender.id != profile.id and transaction_obj.receiver.id != profile.id:
                return Response(
                    {'error': 'You do not have permission to view this transaction'},
                    status=status.HTTP_403_FORBIDDEN
                )
                
            # Prepare response data
            transaction_data = {
                'id': transaction_obj.id,
                'sender': transaction_obj.sender.name,
                'sender_id': transaction_obj.sender.id,
                'receiver': transaction_obj.receiver.name,
                'receiver_id': transaction_obj.receiver.id,
                'amount': transaction_obj.amount,
                'date': transaction_obj.date,
                'status': transaction_obj.status,
                'note': transaction_obj.note,
                'type': 'sent' if transaction_obj.sender.id == profile.id else 'received'
            }
            
            return Response(transaction_data, status=status.HTTP_200_OK)
            
        except Exception as e:
            logger.error(f"Transaction detail error: {str(e)}")
            
            return Response(
                {'error': 'Could not retrieve transaction details.'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
            
            



class ProfileDetailAPIView(APIView):
    """
    API view to retrieve authenticated user's profile details
    and get details of other profiles if permitted
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    
    def get(self, request, profile_id=None):
        """
        Get profile details
        
        If profile_id is provided, get that specific profile (if permitted)
        If no profile_id is provided, get the authenticated user's profile
        """
        try:
            # Get authenticated user's profile
            user_profile = get_object_or_404(Profile, user=request.user)
            
            # If no profile_id is provided, return user's own profile
            if profile_id is None:
                serializer = ProfileSerializer(user_profile)
                return Response(serializer.data, status=status.HTTP_200_OK)
            
            # If profile_id is provided, get that profile
            requested_profile = get_object_or_404(Profile, id=profile_id)
            
           
            serializer = ProfileSerializer(requested_profile)
            return Response(serializer.data, status=status.HTTP_200_OK)
            
        except Profile.DoesNotExist:
            return Response(
                {'error': 'Profile not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            logger.error(f"Profile detail error: {str(e)}")
            return Response(
                {'error': 'Could not retrieve profile details'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

class ProfileUpdateAPIView(APIView):
    """
    API view to update user's profile information
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    
    def put(self, request):
        """
        Update the authenticated user's profile
        """
        try:
            profile = get_object_or_404(Profile, user=request.user)
            
            # Get data from request
            name = request.data.get('name')
            phone = request.data.get('phone')
            email = request.data.get('email')
            app_pin = request.data.get('app_pin')
            borrow_pin = request.data.get('borrow_pin')
            current_app_pin = request.data.get('current_app_pin')
            
            # Verify current PIN if trying to update security-sensitive fields
            if (app_pin or borrow_pin) and (int(current_app_pin or 0) != profile.app_pin):
                return Response(
                    {'error': 'Current PIN verification failed. Cannot update security settings.'},
                    status=status.HTTP_401_UNAUTHORIZED
                )
            
            # Update fields if provided
            if name:
                profile.name = name
            
            if phone:
                profile.phone = phone
                
            if email:
                profile.email = email
                # Also update user's email
                profile.user.email = email
                profile.user.save()
            
            # Validate and update PIN if provided
            if app_pin:
                if not str(app_pin).isdigit() or len(str(app_pin)) != 4:
                    return Response(
                        {'error': 'App PIN must be a 4-digit number'},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                profile.app_pin = app_pin
                
            if borrow_pin:
                if not str(borrow_pin).isdigit() or len(str(borrow_pin)) != 4:
                    return Response(
                        {'error': 'Borrow PIN must be a 4-digit number'},
                        status=status.HTTP_400_BAD_REQUEST
                    )
                profile.borrow_pin = borrow_pin
            
            # Handle image upload if included
            if 'image' in request.FILES:
                profile.image = request.FILES['image']
            
            # Save the updated profile
            profile.save()
            
            # Return the updated profile
            serializer = ProfileSerializer(profile)
            return Response(
                {
                    'message': 'Profile updated successfully',
                    'profile': serializer.data
                },
                status=status.HTTP_200_OK
            )
            
        except Exception as e:
            logger.error(f"Profile update error: {str(e)}")
            return Response(
                {'error': 'Could not update profile'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
            
            
            
            

class ProfileByUsernameAPIView(APIView):
    """
    API view to retrieve a profile by the associated user's username
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    
    def get(self, request, username):
        """
        Get profile details by username
        """
        try:
            # Get the user by username
            user = get_object_or_404(User, username=username)
            
            # Get the associated profile
            profile = get_object_or_404(Profile, user=user)
            
            # You may want to customize what information is visible
            # to other users versus the profile owner
            is_own_profile = request.user.id == user.id
            
            # Use the serializer to format the response
            serializer = ProfileSerializer(profile)
            response_data = serializer.data
            if not is_own_profile:
                if 'app_pin' in response_data:
                    del response_data['app_pin']
                if 'borrow_pin' in response_data:
                    del response_data['borrow_pin']
            
            return Response(response_data, status=status.HTTP_200_OK)
            
        except User.DoesNotExist:
            return Response(
                {'error': 'User not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        except Profile.DoesNotExist:
            return Response(
                {'error': 'Profile not found for this user'},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            logger.error(f"Profile by username error: {str(e)}")
            return Response(
                {'error': 'Could not retrieve profile details'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class SearchProfileAPIView(APIView):
    """
    API view to search for profiles by username, name, or email
    """
    permission_classes = [IsAuthenticated]
    authentication_classes = [JWTAuthentication]
    
    def get(self, request):
        """
        Search for profiles based on query parameter
        """
        try:
            # Get query parameter
            query = request.query_params.get('query', '')
            
            if not query or len(query) < 3:
                return Response(
                    {'error': 'Search query must be at least 3 characters'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Search for matching users (by username)
            users = User.objects.filter(username__icontains=query)
            
            # Search for matching profiles (by name or email)
            profiles_by_name = Profile.objects.filter(name__icontains=query)
            profiles_by_email = Profile.objects.filter(email__icontains=query)
            
            # Combine the results (avoiding duplicates)
            profiles = set()
            
            # Add profiles from users search
            for user in users:
                try:
                    profile = Profile.objects.get(user=user)
                    profiles.add(profile)
                except Profile.DoesNotExist:
                    continue
            
            # Add profiles from direct profile searches
            profiles.update(profiles_by_name)
            profiles.update(profiles_by_email)
            
            # Serialize the profiles
            serializer = ProfileSerializer(profiles, many=True)
            
            # Remove sensitive data from results
            results = []
            for profile_data in serializer.data:
                # Remove sensitive fields
                if 'app_pin' in profile_data:
                    del profile_data['app_pin']
                if 'borrow_pin' in profile_data:
                    del profile_data['borrow_pin']
                
                results.append(profile_data)
            
            return Response(results, status=status.HTTP_200_OK)
            
        except Exception as e:
            logger.error(f"Profile search error: {str(e)}")
            return Response(
                {'error': 'Could not perform profile search'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )