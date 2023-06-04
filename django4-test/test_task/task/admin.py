from django.contrib import admin
from .models import Contract, CreditRequest, Producer, Product

admin.site.register(Contract)
admin.site.register(CreditRequest)
admin.site.register(Producer)
admin.site.register(Product)
