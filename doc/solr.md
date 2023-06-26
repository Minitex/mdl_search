# Solr

- [Solr](#solr)
  - [How it fits in](#how-it-fits-in)
  - [Cores](#cores)
  - [Server setup](#server-setup)
  - [Admin UI](#admin-ui)
    - [Querying from Admin UI](#querying-from-admin-ui)
  - [Troubleshooting](#troubleshooting)

Solr is a search platform based on Apache Lucene. We use it to power
full text and faceted search features on the site. We're currently
running version 6.6

[Reference Guide](https://solr.apache.org/guide/6_6/)

## How it fits in

We use the
[Blacklight](https://github.com/projectblacklight/blacklight/) Rails
engine to provide a search and discovery interface over our catalog of
digital materials. Blacklight transforms a user's queries into Lucene
syntax and issues them to Solr. Blacklight provides many utilities for
rendering the results as either a search results page or a catalog item
details page.

In addition, we use Solr to index OCR results of text-based content in
the catalog in order to provide a "search within document" feature.

## Cores

A core in Solr refers to an index and related configuration and
transaction log data. An application will interact with one or more
cores in a Solr instance to query and update stored/indexed data. A
newly created core starts out empty; but as documents (JSON, in our
case) are posted to it, the index grows and search becomes useful. The
core's configuration file (solrconfig.xml) is used to define various
analyzers, tokenizers, and filters that are applied at query, at index
time, or both. [Solr's
documentation](https://solr.apache.org/guide/6_6/understanding-analyzers-tokenizers-and-filters.html#UnderstandingAnalyzers_Tokenizers_andFilters-UsingAnalyzers_Tokenizers_andFilters)
is the best place to learn more about the details of these operations

This application utilizes two cores; one for the main Blacklight-driven
search and faceting features, and one for the "search within document"
feature. The configuration of both cores lives in [a dedicated
repository on GitHub](https://github.com/Minitex/mdl-solr-core/)

| Core Name       | Purpose
|-----------------|---------
| mdl-1           | search and faceting via Blacklight
| mdl-iiif-search | [IIIF Content Search API](https://iiif.io/api/search/1.0/) (search within document)

## Server setup

In both QA and production, Solr runs on our "database" server, which
also hosts MySQL and the web app itself (Sidekiq jobs run on a dedicated
server). The Solr home directory is `/swadm/solr/server/solr`, and as
long as it's running, Solr should recognize any cores within that
directory. The way we have it set up, the core directories live in
`/swadm/solr-cores/` and are symlinked to `/swadm/solr/server/solr`,
where they're discovered by the running Solr instance.

To start or restart Solr, run:

```bash
/swadm/var/www/mdl/shared/start_solr.sh
```

## Admin UI

Solr comes with a decent admin UI that provides server stats, core
management features, query functionality, and more. We don't expose it
to the internet, however, so you'll need to open an SSH tunnel to the
host server and forward a port on your machine. Then, you can load it up
on your local web browser. For example, to view the admin interface for
QA:

```bash
# Open an SSH tunnel in the foreground, forwarding port 8983 on the remote
# machine to port 18983 on the local machine.
ssh -L 18983:localhost:8983 swadm@mtx-reflectqa-qat2.oit.umn.edu

# Alternatively, you can background it by appending the "-fN" flags, but
# then you'll need to manually find and kill the PID to close the connection.
ssh -L 18983:localhost:8983 swadm@mtx-reflectqa-qat2.oit.umn.edu -fN
```

Then fire up your browser and visit

http://localhost:18983/solr

### Querying from Admin UI

For IIIF Search Service, choose the mdl-iiif-search core in the Core
Selector, and fill in the form with the following: (note "collection:id"
must be replaced with actual collection and id values)

```
fq:
item_id:"collection:id"

fl:
id,item_id,line,canvas_id,word_boundaries:[json]

Raw Query Parameters:
qt=search&hl=on&hl.fl=line&hl.method=unified&facet=true&facet.pivot=item_id&facet.query=item_id:*
```

For the main search core, choose mdl-1 from the Core Selector and fill
in the form with the following:

```
# To find a specific document
fq:
id:"p16022coll548:1013"

Raw Query Parameters:
qt=document

check the edismax checkbox
```

## Troubleshooting

Solr isn't currently managed by Systemd, so if the server gets
restarted, or the process dies for some other reason, it will need to be
manually started up again.

To start or restart Solr, run:

```bash
/swadm/var/www/mdl/shared/start_solr.sh
```

If you notice that cores are missing, maybe after a restart or other
outage, it may be necessary to recreate their symlinks into the Solr
Home directory.

Cores should each have a directory within `/swadm/solr/server/solr/`.
For instance, we expect

```
/swadm/solr/server/solr/mdl-1
```

and

```
/swadm/solr/server/solr/mdl-iiif-search
```

If either of these directories is missing, recreate the symlink as
follows.

```bash
ln -snf /swadm/solr-cores/mdl-iiif-search /swadm/solr/server/solr/mdl-iiif-search

# or

ln -snf /swadm/solr-cores/mdl-1 /swadm/solr/server/solr/mdl-1
```
