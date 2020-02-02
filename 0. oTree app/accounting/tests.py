from otree.api import Currency as c, currency_range
from . import pages
from ._builtin import Bot
import random
from .models import Constants

class PlayerBot(Bot):

    def play_round(self):

        if self.round_number == 1:

            yield (pages.TicketNumber, {'tn': 98765})
            yield (pages.Information, {'accept_conditions': True})
            yield (pages.Instructions1, {'Instr1a': 1, 'Instr1b': 2, 'Instr1c':2})
            yield (pages.Instructions2)
            yield (pages.Instructions2a, {'Instr2aa': 2, 'Instr2ab': 2})
            yield (pages.Instructions2b, {'Instr2ba': 2, 'Instr2bb': 1, 'Instr2bc': 2})
            yield (pages.Instructions3, {'Instr3a': 1, 'Instr3b': 2, 'Instr3c': 1, 'Instr3d': 1})
            yield (pages.Warning, {'accept_payoffs': True})

            if self.group.e_g == c(1):

                if self.player.id_in_group == 1:
                    highr = round(random.uniform(0.8, 1), 2)
                    yield (pages.Stage1, {'r': highr, 'checkr': 1})

                else:
                    if self.group.r == 1:
                        yield (pages.Stage2)
                    if self.group.r>=0.9 and self.group.r<1:
                        yield (pages.Stage2, {'payoff1f': c(5), 'checkpayoff1f': 1})
                    if self.group.r>=0.8 and self.group.r<0.9:
                        yield (pages.Stage2, {'payoff1f': c(6), 'checkpayoff1f': 1})
                yield (pages.Results)

            else:

                if self.player.id_in_group == 1:
                    lowr = round(random.uniform(0.2, 0.8), 2)
                    yield (pages.Stage1, {'r': lowr, 'checkr': 1})

                else:
                    if self.group.r >= 0.6 and self.group.r < 0.8:
                        yield (pages.Stage2, {'payoff1f': c(7), 'checkpayoff1f': 1})
                    if self.group.r >= 0.4 and self.group.r < 0.6:
                        yield (pages.Stage2, {'payoff1f': c(8), 'checkpayoff1f': 1})
                    if self.group.r >= 0.2 and self.group.r < 0.4:
                        yield (pages.Stage2, {'payoff1f': c(9), 'checkpayoff1f': 1})
                    if self.group.r >= 0 and self.group.r < 0.2:
                        yield (pages.Stage2, {'payoff1f': c(10), 'checkpayoff1f': 1})

                yield (pages.Results)

        else:

            if self.player.id_in_group == 1:

                if self.round_number<self.player.participant.vars['shockround']:

                    if self.group.e_g == c(1):
                        highr = round(random.uniform(0.8, 1), 2)
                        yield (pages.Stage1, {'r': highr, 'checkr': 1})

                    else:
                        lowr = round(random.uniform(0.2, 0.8), 2)
                        yield (pages.Stage1, {'r': lowr, 'checkr': 1})

                else:

                    if self.group.e_g == c(1):
                        highr = round(random.uniform(0.8, 1), 2)
                        yield (pages.Stage1, {'r': highr, 'checkr': 1})

                    else:
                        midr = round(random.uniform(0.50, 0.80), 2)
                        yield (pages.Stage1, {'r': midr, 'checkr': 1})

                yield (pages.Results)

            else:
                if self.group.r == 1:
                    yield (pages.Stage2)

                if self.group.r >= 0.9 and self.group.r < 1:
                    yield (pages.Stage2, {'payoff1f': c(5), 'checkpayoff1f': 1})

                if self.group.r >= 0.8 and self.group.r < 0.9:
                    yield (pages.Stage2, {'payoff1f': c(6), 'checkpayoff1f': 1})

                if self.group.r >= 0.6 and self.group.r < 0.8:
                    yield (pages.Stage2, {'payoff1f': c(7), 'checkpayoff1f': 1})

                if self.group.r >= 0.4 and self.group.r < 0.6:
                    yield (pages.Stage2, {'payoff1f': c(8), 'checkpayoff1f': 1})

                if self.group.r >= 0.2 and self.group.r < 0.4:
                    yield (pages.Stage2, {'payoff1f': c(9), 'checkpayoff1f': 1})

                if self.group.r >= 0 and self.group.r < 0.2:
                    yield (pages.Stage2, {'payoff1f': c(10), 'checkpayoff1f': 1})

                yield (pages.Results)