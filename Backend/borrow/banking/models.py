from django.db import models
from django.contrib.auth.models import User
# Create your models here.



class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=200)
    email = models.EmailField(max_length=200)
    phone = models.CharField(max_length=200)
    balance = models.IntegerField(default=0)
    image = models.ImageField(default='default.jpg', upload_to='profile_pics')
    app_pin = models.IntegerField(default=0)
    borrow_pin = models.IntegerField(default=0)

    
    
    
    def __str__(self):
        return self.name
    



class Transaction(models.Model):
    sender = models.ForeignKey(Profile, on_delete=models.CASCADE, related_name='sender')
    receiver = models.ForeignKey(Profile, on_delete=models.CASCADE, related_name='receiver')
    amount = models.IntegerField()
    date = models.DateTimeField(auto_now_add=True)
    status = models.CharField(max_length=200, default='pending')
    note = models.TextField(default='No note')
    
    def __str__(self):
        return str(self.sender) + ' sent ' + str(self.amount) + ' to ' + str(self.receiver) + ' on ' + str(self.date)
    
    
