from django.db import models


class Contract(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.__class__.__name__}: {self.id}'


class CreditRequest(models.Model):
    contract = models.ForeignKey(Contract, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.__class__.__name__}: {self.id}'


class Producer(models.Model):
    name = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.__class__.__name__}: {self.name}'


class Product(models.Model):
    name = models.CharField(max_length=100)
    credit_request = models.ForeignKey(CreditRequest, on_delete=models.CASCADE, blank=True, null=True)
    producer = models.ForeignKey(Producer, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.__class__.__name__}: {self.name}'
