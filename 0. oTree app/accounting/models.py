import itertools
import random
from django.core.validators import RegexValidator

from otree.api import (
    models, widgets, BaseConstants, BaseSubsession, BaseGroup, BasePlayer,
    Currency as c, currency_range
)


author = 'Victor van Pelt'

doc = """
Accounting Systems
"""


class Constants(BaseConstants):
    name_in_url = 'accounting_systems'
    players_per_group = 2
    num_rounds = 12

class Subsession(BaseSubsession):

    def creating_session(self):

        #Random Matching but fixed roles
        self.group_randomly(fixed_id_in_group=True)

        if self.round_number == 1:
            for g in self.get_groups():
                shockround = random.randint(4, 10)
                p1 = g.get_player_by_id(1)
                p1.participant.vars['shockround'] = shockround
                p1.participant.vars['e'] = c(self.session.config['e'])

        else:
            for g in self.get_groups():
                p1 = g.get_player_by_id(1)

                if self.round_number == p1.participant.vars['shockround']:
                    if p1.participant.vars['e'] == c(1):
                         p1.participant.vars['e'] = c(9)

                    else:
                         p1.participant.vars['e'] = c(1)

                else:
                    pass

        for g in self.get_groups():
            g.define_e_group()
            g.calculate_rpayoff1()
            g.define_shockround()

class Group(BaseGroup):

    e_g = models.CurrencyField()

    shockround = models.IntegerField(min=0, max=Constants.num_rounds, initial=None)

    r = models.FloatField(
        widget=widgets.SliderInput(attrs={'step': '0.01', 'style': 'width:500px'}, show_value=False),
        min=0,
        initial=None,
        max=1,
    )

    #For Slider check in Stage 1
    checkr = models.FloatField(blank=True, initial=None)

    #History counter for Stage 1
    historyc1 = models.IntegerField(blank=True, initial=0)

    #History counter for Stage 2
    historyc2 = models.IntegerField(blank=True, initial=0)

    #History counter for results P1
    historyr1 = models.IntegerField(blank=True, initial=0)

    #History counter for results P1
    historyr2 = models.IntegerField(blank=True, initial=0)

    payoff1 = models.CurrencyField()

    payoff1f = models.FloatField(
        widget=widgets.SliderInput(attrs={'step': '0.01', 'style': 'width:500px'}, show_value=False),
        min=5,
        initial=None,
        max=15,
        blank=True
    )

    #For Slider check in Stage 2
    checkpayoff1f = models.FloatField(blank=True, initial=None)

    payoff2 = models.CurrencyField()

    rpayoff1 = models.CurrencyField()

    payoff_p1 = models.CurrencyField()
    payoff_p2 = models.CurrencyField()

    def define_e_group(self):
        p1 = self.get_player_by_id(1)
        self.e_g = p1.participant.vars.get('e')

    def define_shockround(self):
        p1 = self.get_player_by_id(1)
        self.shockround = p1.participant.vars.get('shockround')

    def calculate_rpayoff1(self):
        p1 = self.get_player_by_id(1)
        self.rpayoff1 = c(15) - self.e_g
        #p1.participant.vars.get('e')

    def calculate_payoff1(self):
        if self.r == 1:
            self.payoff1 = None
        else :
            self.payoff1 = c(self.payoff1f)

    def calculate_payoff2(self):
        if self.r == 1:
            self.payoff2 = None
        else :
            self.payoff2 = -1 * (self.payoff1 - c(20))

    #For history table
    def calculate_payoff_p1_p2(self):
        if self.r == 1:
            self.payoff_p1 = self.r * (c(15) - self.e_g)
            self.payoff_p2 = self.r * c(5)
        else:
            self.payoff_p1 = self.r * (c(15) - self.e_g) + (1-self.r) * self.payoff1
            self.payoff_p2 = self.r * c(5) + (1-self.r) * self.payoff2

    def set_payoffs(self):
        p1 = self.get_player_by_id(1)
        p2 = self.get_player_by_id(2)
        if self.r == 1 :
            p1.payoff = self.r * (c(15) - self.e_g)
            p2.payoff = self.r * c(5)
        else :
            p1.payoff = self.r * (c(15) - self.e_g) + (1 - self.r) * self.payoff1
            p2.payoff = self.r * c(5) + (1 - self.r) * self.payoff2

class Player(BasePlayer):

    #Personal code
    tn = models.StringField(blank=False)
    # tn = models.CharField(
    #     blank=False,
    #     max_length=5,
    #     validators=
    #         [RegexValidator(
    #             r'^\d{5}$',
    #             message='Your personal code should have 5 digits',
    #             code='nomatch'
    #             )
    #         ]
    # )

    #Accept the conditions to participate
    accept_conditions = models.BooleanField(blank=False, widget=widgets.CheckboxInput)

    #Instruction1 checks
    Instr1a = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)
    Instr1b = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)
    Instr1c = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)

    #Instructions 2 check
    accept_payoffs = models.BooleanField(blank=False, widget=widgets.CheckboxInput)

    #Instruction2a checks
    Instr2aa = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)
    Instr2ab = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)

    #Instruction2b checks
    Instr2ba = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)
    Instr2bb = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)
    Instr2bc = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)

    Fakeslider2 = models.FloatField(
        widget=widgets.SliderInput(attrs={'step': '0.01', 'style': 'width:450px'}, show_value=False),
        min=0,
        initial=0.5,
        blank=True,
        max=1
    )

    #Instruction3 checks
    Instr3a = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)
    Instr3b = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)
    Instr3c = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)
    Instr3d = models.IntegerField(blank=False, choices=[[1, 'True'],[2, 'False']], widget=widgets.RadioSelect)

    Fakeslider = models.FloatField(
        widget=widgets.SliderInput(attrs={'step': '0.01', 'style': 'width:450px'}, show_value=False),
        min=5,
        blank=True,
        initial=10,
        max=15
    )

    #History counter for Choice
    historyc = models.IntegerField(blank=True, initial=0)

    #History counter for Choice
    historyr = models.IntegerField(blank=True, initial=0)

    def get_partner(self):
        return self.get_others_in_group()[0]