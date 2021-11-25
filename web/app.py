#!/usr/bin/env python
# -*- coding: utf-8 -*-
import flask
from pywikibot.exceptions import APIError
from pywikibot.site import APISite
from requests import get


# create an app instance
app = flask.Flask(__name__, template_folder='.', static_folder='')


# at the end point /
@app.route('/')
# call method index
def index():
  return flask.render_template('index.html')

# at the end point /api
@app.route('/api/')
# call method api
def api():
  entry_points = {'/wikis': 'List of public WMF wikis available to search. [list of db_names]',
                  '/query/<db_name>?q=<query>': 'Search wiki for a query. [list of {title, url} maps]',
                  '/wiki/<db_name>': 'Ask wiki for a human-friently name. [list of a name]'}
  return flask.jsonify(entry_points)

# at the end point /api/wikis
@app.route('/api/wikis')
# call method wikis
def wikis():
  # get all wmf wikis
  all_raw = get('https://noc.wikimedia.org/conf/dblists/all.dblist')
  all = all_raw.text.splitlines()
  # get private wmf wikis
  private_raw = get('https://noc.wikimedia.org/conf/dblists/private.dblist')
  private = private_raw.text.splitlines()
  # no support in pywikibot
  exceptions = [
    'advisorywiki',
    'donatewiki',
    'labtestwiki',
    'loginwiki',
    'nostalgiawiki',
    'qualitywiki',
    'strategywiki',
    'usabilitywiki',
    'votewiki'
  ]
  # support added recently
  exceptions += [
    'etwikimedia',
    'gewikimedia',
    'grwikimedia',
    'hiwikimedia',
    'ngwikimedia',
    'punjabiwikimedia',
    'romdwikimedia',
    'testcommonswiki'
  ]
  # exclude private wmf wikis and exceptions
  return flask.jsonify([name for name in all if name not in private and name not in exceptions])

# at the end point /api/query/<db_name>
@app.route('/api/query/<db_name>')
# call method query
def query(db_name):
  # get the query first
  query = flask.request.args.get('q')
  # get wiki from db_name
  wiki = APISite.fromDBName(db_name)
  # search wiki and publish result
  try:
    results = list(wiki.search(query))
  except APIError as e:
    results = []
    print(e)
  # return output row
  if results:
    results = [{'title': page.title(allow_interwiki=False), 'url': page.full_url()} for page in results]
  return flask.jsonify(results)

# at the end point /api/wiki/<db_name>
@app.route('/api/wiki/<db_name>')
# call method wiki
def wiki(db_name):
  # get wiki from db_name
  wiki = APISite.fromDBName(db_name)
  # return wiki sitename
  return flask.jsonify([wiki.sitename])


# on running python app.py
if __name__ == '__main__':
  # run the flask app
  app.run(debug=True)
