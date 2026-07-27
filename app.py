def multiply_by_two(number):
    return number * 2
import os

# Bandit will flag 'eval' as a critical security risk
user_input = "print('Hello')"
eval(user_input)

# TruffleHog will flag this fake API key as a leaked secret
TRACKING_TOKEN = "AIzaSyA1234567890XYZ-FAKE-KEY-FOR-TESTING"