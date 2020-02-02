import os
from os import environ

import dj_database_url

import otree.settings


#BASE_DIR = os.path.dirname(os.path.abspath(__file__))

OTREE_PRODUCTION = 1

# Debug off
#DEBUG = False

#Debug on
#if OTREE_PRODUCTION not in {None, '', '0'}:
#    DEBUG = False
#else:
#    DEBUG = True

# don't share this with anybody.

SECRET_KEY = 'o2frwpg%(w^4_$qg@)@$w%!wk)&0(qjsi#axt)_d!5@)i6uzy2'



#Enable to run test command
# command otree test accounting --export
#DISABLE WHEN COMMITING TO SERVER TiU
#environ['DATABASE_URL'] = 'postgres://postgres@localhost/django_db'

#test whether to update server tiue
#DATABASES = {
#    'default': dj_database_url.config(
#        default='sqlite:///' + os.path.join(BASE_DIR, 'db.sqlite3')
#    )
#}

# AUTH_LEVEL:
# this setting controls which parts of your site are freely accessible,
# and which are password protected:
# - If it's not set (the default), then the whole site is freely accessible.
# - If you are launching a study and want visitors to only be able to
#   play your app if you provided them with a start link, set it to STUDY.
# - If you would like to put your site online in public demo mode where
#   anybody can play a demo version of your game, but not access the rest
#   of the admin interface, set it to DEMO.

# for flexibility, you can set it in the environment variable OTREE_AUTH_LEVEL
AUTH_LEVEL = environ.get('OTREE_AUTH_LEVEL')

ADMIN_USERNAME = 'admin'
# for security, best to set admin password in an environment variable
ADMIN_PASSWORD = environ.get('OTREE_ADMIN_PASSWORD')

# setting for integration with AWS Mturk
AWS_ACCESS_KEY_ID = environ.get('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = environ.get('AWS_SECRET_ACCESS_KEY')


# e.g. EUR, CAD, GBP, CHF, CNY, JPY
REAL_WORLD_CURRENCY_CODE = 'EUR'
USE_POINTS = True
POINTS_DECIMAL_PLACES = 2
REAL_WORLD_CURRENCY_DECIMAL_PLACES = 2

# e.g. en, de, fr, it, ja, zh-hans
# see: https://docs.djangoproject.com/en/1.9/topics/i18n/#term-language-code
LANGUAGE_CODE = 'en'

# if an app is included in SESSION_CONFIGS, you don't need to list it here
INSTALLED_APPS = [
    'otree'
    #'otreeutils'
]

# SENTRY_DSN = ''

DEMO_PAGE_INTRO_HTML = """
<p>
    Here are various applications implemented with oTree. These applications are all open
    source, and you can modify them as you wish.
</p>
<p>
    <a href="https://www.victorvanpelt.com" target="_blank">
        Personal Website
    </a>
<p>    
<p>
    <a href="https://github.com/victorvanpelt/" target="_blank">
        GitHub Profile
    </a>
</p>
"""

ROOMS = [
    {
        'name': 'live_demo',
        'display_name': 'Room for live demo (no participant labels)',
    },
    {
        'name': 'CenterLab',
        'display_name': 'Room for CenterLab',
        'participant_label_file': 'centerlablabels.txt',
        'use_secure_urls':True,
    },
]


mturk_hit_settings = {
    'keywords': ['bonus', 'study'],
    'title': 'Title for your experiment',
    'description': 'Description for your experiment',
    'frame_height': 500,
    'preview_template': 'global/MTurkPreview.html',
    'minutes_allotted_per_assignment': 60,
    'expiration_hours': 7*24, # 7 days
    #'grant_qualification_id': 'YOUR_QUALIFICATION_ID_HERE',# to prevent retakes
    'qualification_requirements': []
}


# if you set a property in SESSION_CONFIG_DEFAULTS, it will be inherited by all configs
# in SESSION_CONFIGS, except those that explicitly override it.
# the session config can be accessed from methods in your apps as self.session.config,
# e.g. self.session.config['participation_fee']

SESSION_CONFIG_DEFAULTS = {
    'real_world_currency_per_point': 0.06,
    'participation_fee': 0.00,
    'doc': "",
    'mturk_hit_settings': mturk_hit_settings,
}

SESSION_CONFIGS = [
    {
        'name': 'epq',
        'display_name': "Ex-post Questionnaire",
        'num_demo_participants': 1,
        'app_sequence': ['epq'],
    },
    {
        'name': 'bret',
        'display_name': "Bomb Risk Elicitation Task",
        'num_demo_participants': 1,
        'app_sequence': ['bret', 'payment_info'],
    },
    {
        'name': 'accounting_low',
        'display_name': "Accounting System Low",
        'num_demo_participants': 2,
        'app_sequence': ['accounting', 'payment_info'],
        'e': 1,
    },
    {
        'name': 'accounting_high',
        'display_name': "Accounting System High",
        'num_demo_participants': 2,
        'app_sequence': ['accounting', 'payment_info'],
        'e': 9,
    },
    {
        'name': 'accounting_lows',
        'display_name': "Accounting Session Low",
        'num_demo_participants': 2,
        'app_sequence': ['accounting', 'bret', 'epq', 'payment_info'],
        'e': 1,
    },
    {
        'name': 'accounting_highs',
        'display_name': "Accounting Session High",
        'num_demo_participants': 2,
        'app_sequence': ['accounting', 'bret', 'epq', 'payment_info'],
        'e': 9,
    },
]

# anything you put after the below line will override
# oTree's default settings. Use with caution.
otree.settings.augment_settings(globals())
