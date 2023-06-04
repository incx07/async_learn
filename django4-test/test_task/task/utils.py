from .models import CreditRequest, Product
from django.db.models import Subquery


def get_producers_id(contract_id: str) -> set:
    ''' Returns set of unique producers ids for products in credit requests
    '''
    credit_ids =  CreditRequest.objects.filter(contract=contract_id).only('id')
    products = Product.objects.filter(credit_request__in=Subquery(credit_ids))
    return {product.producer_id for product in products}
