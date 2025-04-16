
# This is the serializer needed for the API view
from rest_framework import serializers
from .models import Profile

class ProfileSerializer(serializers.ModelSerializer):
    """
    Serializer for the Profile model
    """
    username = serializers.CharField(source='user.username', read_only=True)
    
    class Meta:
        model = Profile
        fields = [
            'id', 'username', 'name', 'email', 'phone', 
            'balance', 'image', 'app_pin', 'borrow_pin'
        ]
        extra_kwargs = {
            'app_pin': {'write_only': True},  # Hide sensitive data
            'borrow_pin': {'write_only': True},
            'balance': {'read_only': True},  # Balance can't be set during registration
        }