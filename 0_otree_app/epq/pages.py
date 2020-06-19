from otree.api import Currency as c, currency_range
from ._builtin import Page, WaitPage
from .models import Constants
import random
import json

def vars_for_all_templates(self):
    progress = self.progress()
    return {
        'progress': progress
    }

class Introduction(Page):

    form_model = 'player'
    form_fields = ['accept_info']

    def progress(self):
        curpageindex = page_sequence.index(type(self))-1
        progress = curpageindex / tot_pages * 100
        return progress

class Understanding(Page):
    form_model = 'player'
    form_fields = ['und1', 'und2', 'und3', 'und4', 'und5', 'clear1', 'clear2', 'clear3', 'enjoy1', 'enjoy2', 'enjoy3', 'cons1', 'cons2', 'cons3', 'cons4']

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
            curpageindex = page_sequence.index(type(self))
            progress = curpageindex / tot_pages * 100
            return progress

class Survey1(Page):
    form_model = 'player'
    form_fields = [
        'change1',
        'change2',
        'change3',
        'change4',
        'change5',
        'change6',
        'change7',
        'change8',
        'change9',
        'change10',
        'change11',
        'change12',
        'change13',
        'change14',
        'change15',
        'change16',
        'change17'
    ]
    form_labels = [
        'change1',
        'change2',
        'change3',
        'change4',
        'change5',
        'change6',
        'change7',
        'change8',
        'change9',
        'change10',
        'change11',
        'change12',
        'change13',
        'change14',
        'change15',
        'change16',
        'change17'
    ]

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
        #curpageindex = json.loads(self.participant.vars.get('initial_page_sequence')).index(str(self.__class__.__name__))+len(start_pages)
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

class Survey2(Page):
    form_model = 'player'
    form_fields = [
        'indi1',
        'indi2',
        'indi3',
        'indi4',
        'indi5',
        'indi6',
        'indi7',
        'indi8',
        'indi9',
        'indi10',
        'indi11',
        'indi12',
        'indi13',
        'indi14',
        'indi15'
    ]
    form_labels = [
        'indi1',
        'indi2',
        'indi3',
        'indi4',
        'indi5',
        'indi6',
        'indi7',
        'indi8',
        'indi9',
        'indi10',
        'indi11',
        'indi12',
        'indi13',
        'indi14',
        'indi15'
    ]

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
        #curpageindex = json.loads(self.participant.vars.get('initial_page_sequence')).index(str(self.__class__.__name__))+len(start_pages)
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

class Survey3(Page):
    form_model = 'player'
    form_fields = [
        'big1',
        'big2',
        'big3',
        'big4',
        'big5',
        'big6',
        'big7',
        'big8',
        'big9',
        'big10',
    ]
    form_labels = [
        'big1',
        'big2',
        'big3',
        'big4',
        'big5',
        'big6',
        'big7',
        'big8',
        'big9',
        'big10',
    ]

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
        #curpageindex = json.loads(self.participant.vars.get('initial_page_sequence')).index(str(self.__class__.__name__))+len(start_pages)
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

class Survey4(Page):
    form_model = 'player'
    form_fields = [
        'svo1',
        'svo2',
        'svo3',
        'svo4',
        'svo5',
        'svo6',
        'svo7',
        'svo8',
        'svo9'
    ]
    form_labels = [
        'svo1',
        'svo2',
        'svo3',
        'svo4',
        'svo5',
        'svo6',
        'svo7',
        'svo8',
        'svo9'
    ]

    def progress(self):
        #curpageindex = json.loads(self.participant.vars.get('initial_page_sequence')).index(str(self.__class__.__name__))+len(start_pages)
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

class Survey5(Page):
    form_model = 'player'
    form_fields = [
        'ic1',
        'ic2',
        'ic3',
        'ic4',
        'ic5',
        'ic6',
        'ic7',
        'ic8',
        'ic9',
        'ic10'
    ]
    form_labels = [
        'ic1',
        'ic2',
        'ic3',
        'ic4',
        'ic5',
        'ic6',
        'ic7',
        'ic8',
        'ic9',
        'ic10'
    ]

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
        #curpageindex = json.loads(self.participant.vars.get('initial_page_sequence')).index(str(self.__class__.__name__))+len(start_pages)
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

class Survey6(Page):
    form_model = 'player'
    form_fields = [
        'sdo1',
        'sdo2',
        'sdo3',
        'sdo4',
        'sdo5',
        'sdo6',
        'sdo7',
        'sdo8',
        'sdo9',
        'sdo10',
        'sdo11',
        'sdo12',
        'sdo13',
        'sdo14',
        'sdo15',
        'sdo16'
    ]
    form_labels = [
        'sdo1',
        'sdo2',
        'sdo3',
        'sdo4',
        'sdo5',
        'sdo6',
        'sdo7',
        'sdo8',
        'sdo9',
        'sdo10',
        'sdo11',
        'sdo12',
        'sdo13',
        'sdo14',
        'sdo15',
        'sdo16'
    ]

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
        #curpageindex = json.loads(self.participant.vars.get('initial_page_sequence')).index(str(self.__class__.__name__))+len(start_pages)
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

class Survey7(Page):
    form_model = 'player'
    form_fields = [
        'pnfs1',
        'pnfs2',
        'pnfs3',
        'pnfs4',
        'pnfs5',
        'pnfs6',
        'pnfs7',
        'pnfs8',
        'pnfs9',
        'pnfs10',
        'pnfs11'
    ]
    form_labels = [
        'pnfs1',
        'pnfs2',
        'pnfs3',
        'pnfs4',
        'pnfs5',
        'pnfs6',
        'pnfs7',
        'pnfs8',
        'pnfs9',
        'pnfs10',
        'pnfs11'
    ]

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
        #curpageindex = json.loads(self.participant.vars.get('initial_page_sequence')).index(str(self.__class__.__name__))+len(start_pages)
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

class Survey8(Page):
    form_model = 'player'
    form_fields = [
        'trust1',
        'trust2',
        'trust3',
        'trust4',
        'trust5',
        'trust6',
        'trust7',
        'trust8',
        'trust9',
        'trust10',
        'trust11'
    ]
    form_labels = [
        'trust1',
        'trust2',
        'trust3',
        'trust4',
        'trust5',
        'trust6',
        'trust7',
        'trust8',
        'trust9',
        'trust10',
        'trust11'
    ]

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
        #curpageindex = json.loads(self.participant.vars.get('initial_page_sequence')).index(str(self.__class__.__name__))+len(start_pages)
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

class Survey9(Page):
    form_model = 'player'
    form_fields = [
        'grf1',
        'grf2',
        'grf3',
        'grf4',
        'grf5',
        'grf6',
        'grf7',
        'grf8',
        'grf9',
        'grf10',
        'grf11',
        'grf12',
        'grf13',
        'grf14',
        'grf15',
        'grf16',
        'grf17',
        'grf18'
    ]
    form_labels = [
        'grf1',
        'grf2',
        'grf3',
        'grf4',
        'grf5',
        'grf6',
        'grf7',
        'grf8',
        'grf9',
        'grf10',
        'grf11',
        'grf12',
        'grf13',
        'grf14',
        'grf15',
        'grf16',
        'grf17',
        'grf18'
    ]

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
        #curpageindex = json.loads(self.participant.vars.get('initial_page_sequence')).index(str(self.__class__.__name__))+len(start_pages)
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

class Demographics(Page):
    form_model = 'player'
    form_fields = ['gender', 'age', 'nationality', 'studies', 'workexperience', 'degree', 'english']

    def get_form_fields(self):
        fields = self.form_fields
        random.shuffle(fields)
        return fields

    def progress(self):
        curpageindex = page_sequence.index(type(self))
        progress = curpageindex / tot_pages * 100
        return progress

start_pages = [
    Introduction,
    Understanding
]

end_pages = [
    Demographics
]

initial_page_sequence = [
    Survey1,
    Survey2,
    Survey3,
    Survey5,
    Survey7,
    Survey8,
    Survey9
]

page_sequence = [
    Introduction,
    Understanding,
    Survey1,
    Survey2,
    Survey3,
    Survey5,
    Survey7,
    Survey8,
    Survey9,
    Demographics
]

#class MyPage(Page):
#
#    def inner_dispatch(self):
#        page_seq = int(self.__class__.__name__.split('_')[1])
#        page_to_show = json.loads(self.participant.vars.get('initial_page_sequence'))[page_seq]
#        self.__class__ = globals()[page_to_show]
#        return super(globals()[page_to_show], self).inner_dispatch()
#
#for i, _ in enumerate(initial_page_sequence):
#    NewClassName = "Survey_{}".format(i)
#    A = type(NewClassName, (MyPage,), {})
#    locals()[NewClassName] = A
#    page_sequence.append(locals()[NewClassName])

#page_sequence = start_pages + page_sequence + end_pages
#tot_pages = len(start_pages)+len(initial_page_sequence)+len(end_pages)-1
tot_pages = len(page_sequence)-1