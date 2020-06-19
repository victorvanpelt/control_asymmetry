from otree.api import Currency as c, currency_range
from ._builtin import Page, WaitPage
from .models import Constants

class TicketNumber(Page):

    form_model = 'player'
    form_fields = ['tn']

    def is_displayed(self):
        return self.round_number == 1

    def before_next_page(self):
        self.player.participant.vars['tn'] = self.player.tn

class Information(Page):

    form_model = 'player'
    form_fields = ['accept_conditions']

    def is_displayed(self):
        return self.round_number == 1

class Instructions1(Page):

    form_model = 'player'
    form_fields = ['Instr1a', 'Instr1b', 'Instr1c']

    def is_displayed(self):
        return self.round_number == 1

    def error_message(self, values):
        if values["Instr1a"] != 1:
            return 'Your first answer is incorrect. Check the instructions carefully to see which role you will be playing'
        if values["Instr1b"] != 2:
            return 'Your second answer is incorrect. In each period, you will be anonymously re-matched to participants in this session.'
        if values["Instr1c"] != 2:
            return 'Your last answer is incorrect. In each period, both your decisions influence how many points both of you earn.'

class Instructions2(Page):

    def is_displayed(self):
        return self.round_number == 1

class Instructions2a(Page):

    form_model = 'player'
    form_fields = ['Instr2aa', 'Instr2ab']

    def is_displayed(self):
        return self.round_number == 1

    def error_message(self, values):
        if values["Instr2aa"] != 2:
            return 'Your first answer is incorrect. The value for c cannot be lower than 1 point and cannot be higher than 9 points.'
        if values["Instr2ab"] != 2:
            return 'Your second answer is incorrect. Both you and the other player know the value of c when you make a decision.'

class Instructions2b(Page):

    form_model = 'player'
    form_fields = ['Instr2ba', 'Instr2bb', 'Instr2bc', 'Fakeslider2']

    def is_displayed(self):
        return self.round_number == 1

    def error_message(self, values):
        if values["Instr2ba"] != 2:
            return 'Your first answer is incorrect. Player 1 chooses a value for a between 0.00 and 1.00.'
        if values["Instr2bb"] != 1:
            return 'Your second answer is incorrect. When a equals 1.00, Player 1 receives 15 - c points and Player 2 receives 5 points.'
        if values["Instr2bc"] != 2:
            return 'Your last answer is incorrect. When a equals 0.00, Player 1 receives b1 and Player 2 receives b2.'

class Instructions3(Page):

    form_model = 'player'
    form_fields = ['Instr3a', 'Instr3b', 'Instr3c', 'Instr3d','Fakeslider']

    def is_displayed(self):
        return self.round_number == 1

    def error_message(self, values):
        if values["Instr3a"] != 1:
            return 'Your first answer is incorrect. If Player 2 sets b1 to 9 points, then b2 equals 11 points.'
        if values["Instr3b"] != 2:
            return 'Your second answer is incorrect. If Player 2 sets b1 to 5 points, then b2 equals 15 points.'
        if values["Instr3c"] != 1:
            return 'Your third answer is incorrect. If Player 1 sets a to 1.00, then Player 2 cannot choose values for b1 and b2.'
        if values["Instr3d"] != 1:
            return 'Your last answer is incorrect. If Player 1 sets a to 0.00, then Player 1 receives b1 and Player 2 receives b2.'

class Warning(Page):

    form_model = 'player'
    form_fields = ['accept_payoffs']

    def is_displayed(self):
        return self.round_number == 1

class Stage1(Page):

    form_model = 'group'
    form_fields = ['r', 'checkr', 'historyc1']

    def error_message(self, value):
        #if self.group.r == None:
            if value["checkr"] == None:
                return 'Please make a decision using slider'

    def is_displayed(self):
        return self.player.id_in_group == 1

    def vars_for_template(self):
        return{
            'e': float(self.group.e_g),
            'round_number_perc': self.subsession.round_number/Constants.num_rounds * 100,
        }

    def before_next_page(self):
        self.player.historyc = self.group.historyc1

class WaitForP1(WaitPage):
    pass

class Stage2(Page):

    form_model = 'group'
    form_fields = ['payoff1f', 'checkpayoff1f', 'historyc2']

    def error_message(self, value):
        if self.group.r < 1:
            if value["checkpayoff1f"] == None:
                return 'Please make a decision using slider'

    def vars_for_template(self):
        return{
            'e': float(self.group.e_g),
            'r': self.group.r,
            'r_i2': 1.00 - self.group.r,
            'r_i': round(1.00 - self.group.r, 2),
            'rpayoff1': self.group.r*(15-float(self.group.e_g)),
            'rpayoff2': self.group.r*5,
            'round_number_perc': self.subsession.round_number / Constants.num_rounds * 100
        }

    def is_displayed(self):
        return self.player.id_in_group == 2

    def before_next_page(self):
        self.player.historyc = self.group.historyc2

class ResultsWaitPage(WaitPage):

    def after_all_players_arrive(self):
        self.group.calculate_payoff1()
        self.group.calculate_payoff2()
        self.group.calculate_payoff_p1_p2()
        self.group.set_payoffs()

class Results(Page):

    form_model = 'group'
    form_fields = ['historyr1', 'historyr2']

    def before_next_page(self):
        self.player.historyr = self.group.historyr1
        self.player.historyr = self.group.historyr2

    def vars_for_template(self):
            return {
                'round_number_perc': self.subsession.round_number / Constants.num_rounds * 100
            }

class ShuffleWaitPage(WaitPage):
    wait_for_all_groups = True

    def is_displayed(self):
        return self.subsession.round_number != Constants.num_rounds

page_sequence = [
    TicketNumber,
    Information,
    Instructions1,
    Instructions2,
    Instructions2a,
    Instructions2b,
    Instructions3,
    Warning,
    Stage1,
    WaitForP1,
    Stage2,
    ResultsWaitPage,
    Results,
    ShuffleWaitPage
]
