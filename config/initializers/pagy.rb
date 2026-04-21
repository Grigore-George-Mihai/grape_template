# frozen_string_literal: true

Pagy::OPTIONS[:limit] = 25                 # Limit the items per page
Pagy::OPTIONS[:client_max_limit] = 100     # The client can request a limit up to 100
Pagy::OPTIONS[:max_pages] = 1000           # Allow only 200 pages
