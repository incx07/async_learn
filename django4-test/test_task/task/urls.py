from django.urls import path

from . import views

urlpatterns = [
    path("", views.IndexView.as_view(), name="index"),
    path("contracts", views.ContractListView.as_view(), name="contract-list"),
    path("credits", views.CreditRequestListView.as_view(), name="credit-list"),
    path("producers", views.ProducerListView.as_view(), name="producer-list"),
    path("products", views.ProductListView.as_view(), name="product-list"),
]
