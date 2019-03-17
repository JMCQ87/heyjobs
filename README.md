### AdSync Service

The AdSync service compares campaigns from the remote with the local version.

## Project setup

This project uses RVM, with Ruby 2.6.1 and a Gemset called 'heyjobs'. After the
env is set up, install the dependencies with `bundle` and run the specs with
`rspec`.

## Project structure

The service is split in two parts. One part, dedicated to the retrieval of
campaign states only (load_ad_states), from a local JSON and a remote to compare
to. The other (sync_ads) is dedicated to the comparison of the states of a set of
campaigns to give an output about the differences.

The corresponding RSpec tests are in the spec folder.

## Assumptions

At the current stage, it is considered that there might be campaigns that are
only in the local state, but not in the remote. However, the case in the other
direction, with a campaign that is only on the remote, but not represented
locally

Furthermore, it is also implicitly assumed that the campaign references are
unique and consistent between local and remote and there is no initial effort
to match up the one with the other needed.

Beyond 'reference' as the identifier, there are no hard-coded assumptions about
the attributes a campaign might have.

As there is no logic to re-try campaign state retrieval from the remote, it is
also assumed that this endpoint works reliably and/or that this is handled by
the part of the application that invokes the service.
