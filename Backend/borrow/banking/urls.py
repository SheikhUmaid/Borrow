from django.urls import path

from django.views.decorators.csrf import csrf_exempt

from .views import (RegisterAPIView, CustomTokenObtainPairView, TransactionAPIView, ProfileDetailAPIView, ProfileUpdateAPIView, ProfileByUsernameAPIView, SearchProfileAPIView, CustomTokenRefreshView)



urlpatterns = [
    # path('', test),
    path('api/register/', RegisterAPIView.as_view(), name='register'),
    path('api/refresh/', (CustomTokenRefreshView.as_view()), name='token_refresh'),
    path('api/login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('api/transactions/', TransactionAPIView.as_view(), name='transactions'),
    path('api/profile/', ProfileDetailAPIView.as_view(), name='profile-detail'),
    path('api/profile/<int:profile_id>/', ProfileDetailAPIView.as_view(), name='other-profile-detail'),
    path('api/profile/update/', ProfileUpdateAPIView.as_view(), name='profile-update'),
    
    path('api/profile/username/<str:username>/', ProfileByUsernameAPIView.as_view(), name='profile-by-username'),
    path('api/profiles/search/', SearchProfileAPIView.as_view(), name='profile-search'),
]