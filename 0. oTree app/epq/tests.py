from otree.api import Currency as c, currency_range
from . import pages
from ._builtin import Bot
from .models import Constants


class PlayerBot(Bot):

    def play_round(self):
        yield (pages.Introduction, {'accept_info': True})
        yield (pages.Survey1, {'name': 'VictorBot', 'age': 90})
