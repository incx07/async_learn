from django.views.generic.list import ListView
from django.views.generic.base import TemplateView

from .models import Contract, CreditRequest, Producer, Product
from .utils import get_producers_id


class IndexView(TemplateView):
    template_name = 'task/index.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        if contract_id := self.request.GET.get("get_producers"):
            if not contract_id.isdigit():
                context['error'] = 'You should enter a number!'
                return context
            producers_id = get_producers_id(contract_id)
            context['producers_id'] = producers_id
        return context


class ContractListView(ListView):
    model = Contract


class CreditRequestListView(ListView):
    model = CreditRequest


class ProducerListView(ListView):
    model = Producer


class ProductListView(ListView):
    model = Product
