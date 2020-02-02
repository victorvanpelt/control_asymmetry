from otree.api import (
    models, widgets, BaseConstants, BaseSubsession, BaseGroup, BasePlayer,
    Currency as c, currency_range
)
import random
import itertools
import json

author = 'Victor van Pelt'

doc = """
Ex-post Questionnaire for Accounting Systems
"""


class Constants(BaseConstants):
    name_in_url = 'epq'
    players_per_group = None
    num_rounds = 1
    StandardChoices=[
        [1, 'Disagree strongly'],
        [2, 'Disagree moderately'],
        [3, 'Disagree a little'],
        [4, 'Neither agree nor disagree'],
        [5, 'Agree a little'],
        [6, 'Agree moderately'],
        [7, 'Agree strongly'],
    ]

    #Survey1
    Survey1Choices=StandardChoices

    #Survey2
    Survey2Choices=StandardChoices

    #Survey3
    Survey3Choices=StandardChoices

    #Survey4
    Survey4Choices=StandardChoices

    #Survey5
    Survey5Choices=StandardChoices

    #Survey6
    Survey6Choices=StandardChoices

    #Survey7
    Survey7Choices = StandardChoices

    #Survey8
    Survey8Choices = StandardChoices

    #Survey9
    Survey9Choices = StandardChoices

class Subsession(BaseSubsession):

    def creating_session(self):
        from .pages import initial_page_sequence
        aaa = [i.__name__.split('_') for i in initial_page_sequence]
        page_blocks = [list(group) for key, group in itertools.groupby(aaa, key=lambda x: x[0])]
        for p in self.get_players():
            pb = page_blocks.copy()
            random.shuffle(pb)
            level1 = list(itertools.chain.from_iterable(pb))
            level2 = ['_'.join(i) for i in level1]
            p.participant.vars['initial_page_sequence'] = json.dumps(level2)

class Group(BaseGroup):
    pass


class Player(BasePlayer):

    #Introduction
    accept_info = models.BooleanField(blank=False, widget=widgets.CheckboxInput)

    #Demographics
    gender = models.IntegerField(
        label="Please select your gender.",
        blank=False,
        choices=[
            [1, 'Male'],
            [2, 'Female'],
            [3, 'Other'],
        ]
    )

    age = models.IntegerField(label="Please enter your age.", min=14, max=90, blank=False)

    nationality = models.IntegerField(
        label="Please select what best describes your nationality.",
        blank=False,
        choices=[
            [1, 'Dutch'],
            [2, 'Other European nationality than Dutch'],
            [3, 'Other nationality than a European nationality'],
        ]
    )

    studies = models.IntegerField(
        label="Please estimate how many studies you have participated in since you started studying at this university (excluding this study)",
        blank=False,
        choices=[
            [1, 'Less than 5 studies'],
            [2, 'Between 5 and less than 10 studies.'],
            [3, 'between 10 and less than 15 studies.'],
            [4, '15 or more studies.'],
        ]
    )

    workexperience = models.IntegerField(
        label="Please indicate your work experience. All jobs count, including part-time and volunteer work.",
        blank=False,
        choices=[
            [1, 'I do not have work experience.'],
            [2, 'Less than 1 year work experience.'],
            [3, 'Between 1 and less than 2 years of work experience'],
            [4, 'Between 2 and less than 3 years work experience.'],
            [5, 'Between 3 and less than 4 years work experience.'],
            [6, 'Between 4 and less than 5 years work experience.'],
            [7, '5 years or more work experience.'],
        ]
    )

    degree = models.IntegerField(
        label="Please indicate which degree you are currently pursuing. If you are currently pursuing more than one degree, please select the highest degree.",
        blank=False,
        choices=[
            [1, 'Bachelor degree'],
            [2, 'Master degree'],
            [3, 'PhD degree'],
            [4, 'MBA degree'],
            [5, 'Other'],
        ]
    )

    english = models.IntegerField(
        label="Please rate your English on a percentage scale between 0 and 100.",
        min=0,
        max=100,
        blank=False,
        initial=None
    )

    #Understanding
    und1 = models.IntegerField(
        label="In each period, I chose the value for a.",
        choices= [
            [1, 'True'],
            [2, 'False'],
            [3, 'I do not know']
        ]
    )

    und2 = models.IntegerField(
        label="What best describes the value of c across the periods?",
        choices=[
            [1, 'c was always 9 points'],
            [2, 'c was always 1 point'],
            [3, 'c was 1 point first and 9 points later.'],
            [4, 'c was 9 points first and 1 point later.'],
            [5, 'c varied back and forth between 1 point and 9 points.'],
            [6, 'I do not know']
        ]
    )

    und3 = models.IntegerField(
        label="I was Player 2.",
        choices= [
            [1, 'True'],
            [2, 'False'],
            [3, 'I do not know']
        ]
    )

    und4 = models.IntegerField(
        label="In each period, I chose the values for b1 and b2.",
        choices= [
            [1, 'True'],
            [2, 'False'],
            [3, 'I do not know']
        ]
    )
    clear1 = models.IntegerField(
        label="The information presented to me in this study was clear.",
        choices=Constants.StandardChoices
    )
    clear2 = models.IntegerField(
        label="This study was difficult for me to understand.",
        choices=Constants.StandardChoices
    )
    clear3 = models.IntegerField(
        label="It was not easy to understand the context described to me.",
        choices=Constants.StandardChoices
    )
    enjoy1= models.IntegerField(
        label="I was motivated to participate in this experiment.",
        choices=Constants.StandardChoices
    )
    enjoy2= models.IntegerField(
        label="I enjoyed participating in this study.",
        choices=Constants.StandardChoices
    )
    enjoy3 = models.IntegerField(
        label="This study did not hold my attention.",
        choices=Constants.StandardChoices
    )
    cons1 = models.IntegerField(
        label="Consistency in my decisions across periods was important to me.",
        choices= Constants.StandardChoices
    )
    cons2 = models.IntegerField(
        label="In a period, I considered how the other participant would interpret my decision.",
        choices=Constants.StandardChoices
    )
    cons3 = models.IntegerField(
        label="The value of c influenced my decisions.",
        choices=Constants.StandardChoices
    )
    cons4 = models.IntegerField(
        label="The other participants' decisions influenced the decisions I made.",
        choices=Constants.StandardChoices
    )

    #Survey1 - Resistance to Change
    change1 = models.IntegerField(
        label='I generally consider changes to be a negative thing.',
        choices=Constants.Survey1Choices
    )
    change2 = models.IntegerField(
        label='I will take a routine day over a day full of unexpected events any time.',
        choices=Constants.Survey1Choices
    )
    change3 = models.IntegerField(
        label='I like to do the same old things rather than try new and different ones.',
        choices=Constants.Survey1Choices
    )
    change4 = models.IntegerField(
        label='Whenever my life forms a stable routine, I look for ways to change it.',
        choices=Constants.Survey1Choices
    )
    change5 = models.IntegerField(
        label='I would rather be bored than surprised.',
        choices=Constants.Survey1Choices
    )
    change6 = models.IntegerField(
        label='If I were to be informed that there is going to be a significant change regarding the way things are done at university, I would probably feel stressed.',
        choices=Constants.Survey1Choices
    )
    change7 = models.IntegerField(
        label='When I am informed of a change of plans, I tense up a bit.',
        choices=Constants.Survey1Choices
    )
    change8 = models.IntegerField(
        label='When things do not go according to plans, it stresses me out.',
        choices=Constants.Survey1Choices
    )
    change9 = models.IntegerField(
        label='If one of my professors changed the grading criteria, it would probably make me feel uncomfortable even if I thought I would do just as well without having to do extra work.  ',
        choices=Constants.Survey1Choices
    )
    change10 = models.IntegerField(
        label='Changing plans seems like a real hassle to me.',
        choices=Constants.Survey1Choices
    )
    change11 = models.IntegerField(
        label='Often, I feel a bit uncomfortable even about changes that may potentially improve my life.',
        choices=Constants.Survey1Choices
    )
    change12 = models.IntegerField(
        label='When someone pressures me to change something, I tend to resist it even if I think the change may ultimately benefit me.',
        choices=Constants.Survey1Choices
    )
    change13 = models.IntegerField(
        label='I sometimes find myself avoiding changes that I know will be good for me.',
        choices=Constants.Survey1Choices
    )
    change14 = models.IntegerField(
        label='I often change my mind.',
        choices=Constants.Survey1Choices
    )
    change15 = models.IntegerField(
        label='I do not change my mind easily.',
        choices=Constants.Survey1Choices
    )
    change16 = models.IntegerField(
        label='Once I have come to a conclusion, I am not likely to change my mind.',
        choices=Constants.Survey1Choices
    )
    change17 = models.IntegerField(
        label='My views are very consistent over time.',
        choices=Constants.Survey1Choices
    )


    #Survey2 - Indecisiveness
    indi1 = models.IntegerField(
        label='I try to put off making decisions',
        choices=Constants.Survey2Choices
    )
    indi2 = models.IntegerField(
        label='I always know exactly what I want.',
        choices=Constants.Survey2Choices
    )
    indi3 = models.IntegerField(
        label='I find it easy to make decisions.',
        choices=Constants.Survey2Choices
    )
    indi4 = models.IntegerField(
        label='I have a hard time planning my free time.',
        choices=Constants.Survey2Choices
    )
    indi5 = models.IntegerField(
        label='I like to be in a position to make decisions.',
        choices=Constants.Survey2Choices
    )
    indi6 = models.IntegerField(
        label='Once I make a decision, I feel fairly confident that it is a good one.',
        choices=Constants.Survey2Choices
    )
    indi7 = models.IntegerField(
        label='When ordering from a menu, I usually find it difficult to decide what to get.',
        choices=Constants.Survey2Choices
    )
    indi8 = models.IntegerField(
        label='I usually make decisions quickly.',
        choices=Constants.Survey2Choices
    )
    indi9 = models.IntegerField(
        label='Once I make a decision, I stop worrying about it.',
        choices=Constants.Survey2Choices
    )
    indi10 = models.IntegerField(
        label='I become anxious when making a decision.',
        choices=Constants.Survey2Choices
    )
    indi11 = models.IntegerField(
        label='I often worry about making the wrong choice.',
        choices=Constants.Survey2Choices
    )
    indi12 = models.IntegerField(
        label='After I have chosen or decided something, I often believe I have made the wrong choice or decision.',
        choices=Constants.Survey2Choices
    )
    indi13 = models.IntegerField(
        label='I do not get assignments done on time because I cannot decide what to do first.',
        choices=Constants.Survey2Choices
    )
    indi14 = models.IntegerField(
        label='I have trouble completing assignments because I cannot prioritize what is most important.',
        choices=Constants.Survey2Choices
    )
    indi15 = models.IntegerField(
        label='It seems that deciding on the most trivial thing takes me a long time.',
        choices=Constants.Survey2Choices
    )

    #Survey3 - Big5 short
    big1 = models.IntegerField(
        label='I see myself as extraverted, enthusiastic.',
        choices=Constants.Survey3Choices
    )
    big2 = models.IntegerField(
        label='I see myself as critical, quarrelsome.',
        choices=Constants.Survey3Choices
    )
    big3 = models.IntegerField(
        label='I see myself as dependable, self-disciplined.',
        choices=Constants.Survey3Choices
    )
    big4 = models.IntegerField(
        label='I see myself as anxious, easily upset.',
        choices=Constants.Survey3Choices
    )
    big5 = models.IntegerField(
        label='I see myself as open to new experiences, complex.',
        choices=Constants.Survey3Choices
    )
    big6 = models.IntegerField(
        label='I see myself as reserved, quiet.',
        choices=Constants.Survey3Choices
    )
    big7 = models.IntegerField(
        label='I see myself as sympathetic, warm.',
        choices=Constants.Survey3Choices
    )
    big8 = models.IntegerField(
        label='I see myself as disorganized, careless.',
        choices=Constants.Survey3Choices
    )
    big9 = models.IntegerField(
        label='I see myself as calm, emotionally stable.',
        choices=Constants.Survey3Choices
    )
    big10 = models.IntegerField(
        label='I see myself as conventional, uncreative.',
        choices=Constants.Survey3Choices
    )

    # Survey4
    svo1 = models.IntegerField(
        label='Choice 1',
        choices=[
            [1, 'A. I get 480 and Other gets 80'],
            [2, 'B. I get 540 and Other gets 280'],
            [3, 'C. I get 480 and Other gets 480'],
        ]
    )
    svo2 = models.IntegerField(
        label='Choice 2',
        choices=[
            [1, 'A. I get 560 and Other gets 300'],
            [2, 'B. I get 500 and Other gets 500'],
            [3, 'C. I get 500 and Other gets 100'],
        ]
    )
    svo3 = models.IntegerField(
        label='Choice 3',
        choices=[
            [1, 'A.	I get 520 and Other gets 520'],
            [2, 'B.	I get 520 and Other gets 120'],
            [3, 'C.	I get 580 and Other gets 320'],
        ]
    )
    svo4 = models.IntegerField(
        label='Choice 4',
        choices=[
            [1, 'A.	I get 500 and Other gets 100'],
            [2, 'B.	I get 560 and Other gets 300'],
            [3, 'C.	I get 490 and Other gets 490'],
        ]
    )
    svo5 = models.IntegerField(
        label='Choice 5',
        choices=[
            [1, 'A.	I get 560 and Other gets 300'],
            [2, 'B.	I get 500 and Other gets 500'],
            [3, 'C.	I get 490 and Other gets 90'],
        ]
    )
    svo6 = models.IntegerField(
        label='Choice 6',
        choices=[
            [1, 'A.	I get 500 and Other gets 500'],
            [2, 'B.	I get 500 and Other gets 100'],
            [3, 'C.	I get 570 and Other gets 300'],
        ]
    )
    svo7 = models.IntegerField(
        label='Choice 7',
        choices=[
            [1, 'A.	I get 510 and Other gets 510'],
            [2, 'B.	I get 560 and Other gets 300'],
            [3, 'C.	I get 510 and Other gets 110'],
        ]
    )
    svo8 = models.IntegerField(
        label='Choice 8',
        choices=[
            [1, 'A.	I get 550 and Other gets 300'],
            [2, 'B.	I get 500 and Other gets 100'],
            [3, 'C.	I get 500 and Other gets 500'],
        ]
    )
    svo9 = models.IntegerField(
        label='Choice 9',
        choices=[
            [1, 'A.	I get 480 and Other gets 100'],
            [2, 'B.	I get 490 and Other gets 490'],
            [3, 'C.	I get 540 and Other gets 300'],
        ]
    )

    #Survey5 Interpersonal control
    ic1 = models.IntegerField(
        label='In my personal relationships, the other person usually has more control than I do.',
        choices=Constants.Survey5Choices
    )
    ic2 = models.IntegerField(
        label='I have no trouble making and keeping friends.',
        choices=Constants.Survey5Choices
    )
    ic3 = models.IntegerField(
        label='I am not good at guiding the course of a conversation with several others.',
        choices=Constants.Survey5Choices
    )
    ic4 = models.IntegerField(
        label='I can usually develop a personal relationship with someone I find appealing.',
        choices=Constants.Survey5Choices
    )
    ic5 = models.IntegerField(
        label='I can usually steer a conversation toward the topics I want to talk about.',
        choices=Constants.Survey5Choices
    )
    ic6 = models.IntegerField(
        label='When I need assistance with something, I often find it difficult to get others to help.',
        choices=Constants.Survey5Choices
    )
    ic7 = models.IntegerField(
        label='If there is someone I want to meet, I can usually arrange it.',
        choices=Constants.Survey5Choices
    )
    ic8 = models.IntegerField(
        label='I often find it hard to get my point of view across to others.',
        choices=Constants.Survey5Choices
    )
    ic9 = models.IntegerField(
        label='In attempting to smooth over a disagreement, I sometimes make it worse.',
        choices=Constants.Survey5Choices
    )
    ic10 = models.IntegerField(
        label='I find it easy to play an important part in most group situations.',
        choices=Constants.Survey5Choices
    )

    #Survey6
    sdo1 = models.IntegerField(
        label='Some groups of people must be kept in their place.',
        choices=Constants.Survey6Choices
    )
    sdo2 = models.IntegerField(
        label='It is probably a good thing that certain groups are at the top and other groups are at the bottom.',
        choices=Constants.Survey6Choices
    )
    sdo3 = models.IntegerField(
        label='An ideal society requires some groups to be on top and others to be on the bottom.',
        choices=Constants.Survey6Choices
    )
    sdo4 = models.IntegerField(
        label='Some groups of people are simply inferior to other groups.',
        choices=Constants.Survey6Choices
    )
    sdo5 = models.IntegerField(
        label='Groups at the bottom are just as deserving as groups at the top.',
        choices=Constants.Survey6Choices
    )
    sdo6 = models.IntegerField(
        label='No one group should dominate in society.',
        choices=Constants.Survey6Choices
    )
    sdo7 = models.IntegerField(
        label='Groups at the bottom should not have to stay in their place.',
        choices=Constants.Survey6Choices
    )
    sdo8 = models.IntegerField(
        label='Group dominance is a poor principle.',
        choices=Constants.Survey6Choices
    )
    sdo9 = models.IntegerField(
        label='We should not push for group equality.',
        choices=Constants.Survey6Choices
    )
    sdo10 = models.IntegerField(
        label='We should not try to guarantee that every group has the same quality of life.',
        choices=Constants.Survey6Choices
    )
    sdo11 = models.IntegerField(
        label='It is unjust to try to make groups equal.',
        choices=Constants.Survey6Choices
    )
    sdo12 = models.IntegerField(
        label='Group equality should not be our primary goal.',
        choices=Constants.Survey6Choices
    )
    sdo13 = models.IntegerField(
        label='We should work to give all groups an equal chance to succeed.',
        choices=Constants.Survey6Choices
    )
    sdo14 = models.IntegerField(
        label='We should do what we can to equalize conditions for different groups.',
        choices=Constants.Survey6Choices
    )
    sdo15 = models.IntegerField(
        label='No matter how much effort it takes, we ought to strive to ensure that all groups have the same chance in life.',
        choices=Constants.Survey6Choices
    )
    sdo16 = models.IntegerField(
        label='Group equality should be our ideal.',
        choices=Constants.Survey6Choices
    )

    #Survey7
    pnfs1 = models.IntegerField(
        label='It upsets me to go into a situation without knowing what I can expect from it.',
        choices=Constants.Survey7Choices
    )
    pnfs2 = models.IntegerField(
        label='I am not bothered by things that interrupt my daily routine.',
        choices=Constants.Survey7Choices
    )
    pnfs3 = models.IntegerField(
        label='I enjoy having a clear and structured mode of life.',
        choices=Constants.Survey7Choices
    )
    pnfs4 = models.IntegerField(
        label='I like to have a place for everything and everything in its place.',
        choices=Constants.Survey7Choices
    )
    pnfs5 = models.IntegerField(
        label='I find that a well-ordered life with regular hours makes my life tedious.',
        choices=Constants.Survey7Choices
    )
    pnfs6 = models.IntegerField(
        label='I do not like situations that are uncertain.',
        choices=Constants.Survey7Choices
    )
    pnfs7 = models.IntegerField(
        label='I hate to change my plans at the last minute.',
        choices=Constants.Survey7Choices
    )
    pnfs8 = models.IntegerField(
        label='I hate to be with people who are unpredictable.',
        choices=Constants.Survey7Choices
    )
    pnfs9 = models.IntegerField(
        label='I find that a consistent routine enables me to enjoy life more.',
        choices=Constants.Survey7Choices
    )
    pnfs10 = models.IntegerField(
        label='I enjoy the exhilaration of being in unpredictable situations.',
        choices=Constants.Survey7Choices
    )
    pnfs11 = models.IntegerField(
        label='I become uncomfortable when the rules in a situation are not clear.',
        choices=Constants.Survey7Choices
    )

    #Survey8
    trust1 = models.IntegerField(
        label='Generally speaking, most people can be trusted.',
        choices=Constants.Survey8Choices
    )
    trust2 = models.IntegerField(
        label='Generally speaking, you cannot be too careful in dealing with people.',
        choices=Constants.Survey8Choices
    )
    trust3 = models.IntegerField(
        label='Most of the time people try to be helpful.',
        choices=Constants.Survey8Choices
    )
    trust4 = models.IntegerField(
        label='Most of the time people are mostly just looking out for themselves.',
        choices=Constants.Survey8Choices
    )
    trust5 = models.IntegerField(
        label='Most people would try to take advantage of you if they got the chance.',
        choices=Constants.Survey8Choices
    )
    trust6= models.IntegerField(
        label='Most people would try to be fair.',
        choices=Constants.Survey8Choices
    )
    trust7 = models.IntegerField(
        label='These days you cannot count on strangers.',
        choices=Constants.Survey8Choices
    )
    trust8 = models.IntegerField(
        label='I will trust a person until I have clear evidence that that person cannot be trusted.',
        choices=Constants.Survey8Choices
    )
    trust9 = models.IntegerField(
        label='In dealing with strangers, one is better off to be cautious until they have provided evidence to be trustworthy.',
        choices=Constants.Survey8Choices
    )
    trust10 = models.IntegerField(
        label='I am relatively cautious when I interact with other people.',
        choices=Constants.Survey8Choices
    )
    trust11 = models.IntegerField(
        label='Anyone who completely trusts anyone else is asking for trouble.',
        choices=Constants.Survey8Choices
    )

    #Survey9
    grf1 = models.IntegerField(
        label='In general, I am focused on preventing negative events in my life.',
        choices=Constants.Survey7Choices
    )
    grf2 = models.IntegerField(
        label='I am anxious that I will fall short of my responsibilities and obligations.',
        choices=Constants.Survey7Choices
    )
    grf3 = models.IntegerField(
        label='I frequently imagine how I will achieve my hopes and aspirations.',
        choices=Constants.Survey7Choices
    )
    grf4 = models.IntegerField(
        label='I often think about the person I am afraid I might become in the future.',
        choices=Constants.Survey7Choices
    )
    grf5 = models.IntegerField(
        label='I often think about the person I would ideally like to be in the future.',
        choices=Constants.Survey7Choices
    )
    grf6 = models.IntegerField(
        label='I typically focus on the success I hope to achieve in the future.',
        choices=Constants.Survey7Choices
    )
    grf7 = models.IntegerField(
        label='I often worry that I will fail to accomplish my academic goals.',
        choices=Constants.Survey7Choices
    )
    grf8 = models.IntegerField(
        label='I often think about how I will achieve academic success.',
        choices=Constants.Survey7Choices
    )
    grf9 = models.IntegerField(
        label='I often imagine myself experiencing bad things that I fear might happen to me.',
        choices=Constants.Survey7Choices
    )
    grf10 = models.IntegerField(
        label='I frequently think about how I can prevent failures in my life.',
        choices=Constants.Survey7Choices
    )
    grf11 = models.IntegerField(
        label='I am more oriented toward preventing losses than I am toward achieving gains.',
        choices=Constants.Survey7Choices
    )
    grf12 = models.IntegerField(
        label='My major goal in school right now is to achieve my academic ambitions.',
        choices=Constants.Survey7Choices
    )
    grf13 = models.IntegerField(
        label='My major goal in school right now is to avoid becoming an academic failure.',
        choices=Constants.Survey7Choices
    )
    grf14 = models.IntegerField(
        label='I see myself as someone who is primarily striving to reach my “ideal self ” — to fulfill my hopes, wishes, and aspirations.',
        choices=Constants.Survey7Choices
    )
    grf15 = models.IntegerField(
        label='I see myself as someone who is primarily striving to become the self I “ought” to be — to fulfill my duties, responsibilities, and obligations.',
        choices=Constants.Survey7Choices
    )
    grf16 = models.IntegerField(
        label='In general, I am focused on achieving positive outcomes in my life.',
        choices=Constants.Survey7Choices
    )
    grf17 = models.IntegerField(
        label='I often imagine myself experiencing good things that I hope will happen to me.',
        choices=Constants.Survey7Choices
    )
    grf18 = models.IntegerField(
        label='Overall, I am more oriented toward achieving success than preventing failure.',
        choices=Constants.Survey7Choices
    )

