---@meta

-- ---------------------------------------------------------------------------- --
--                                   Aliases                                    --
-- ---------------------------------------------------------------------------- --

---@alias req.CookieStore userdata

---@alias req.Resolve fun(host: string): string[]

---@alias req.HeaderValue string|string[]|fun():string|fun():string[]

---@alias req.HttpMethod "GET"|"POST"|"PUT"|"PATCH"|"DELETE"|"HEAD"|"OPTIONS"

---@alias req.QueryScalar string|number|boolean
---@alias req.QueryValue req.QueryScalar|req.QueryScalar[]
---@alias req.QueryParams table<string, req.QueryValue>

-- ---------------------------------------------------------------------------- --
--                                Client & Opts                                 --
-- ---------------------------------------------------------------------------- --

---@class req.ClientOptions
---@field headers? table<string, req.HeaderValue> Default HTTP headers
---@field hostname_verification? boolean
---@field certs_verification? boolean
---@field tls_sni? boolean
---@field connect_timeout? integer
---@field connection_verbose? boolean
---@field pool_idle_timeout? integer
---@field pool_max_idle_per_host? integer
---@field tcp_keepalive? integer
---@field tcp_keepalive_interval? integer
---@field tcp_keepalive_retries? integer
---@field tcp_user_timeout? integer
---@field identity? req.Identity
---@field proxies? req.ProxyMatcher[]
---@field auto_sys_proxy? boolean
---@field redirect_policy? req.RedirectPolicy
---@field retry_policy? req.RetryBuilder
---@field referer? boolean
---@field read_timeout? integer
---@field root_certs? req.Certificate[]
---@field tls_built_in_root_certs? boolean
---@field crls? req.CertificateRevocationList[]
---@field min_tls_version? string
---@field max_tls_version? string
---@field tls_info? boolean
---@field http_version_pref? string
---@field http09_responses? boolean
---@field http1_title_case_headers? boolean
---@field http1_allow_obsolete_multiline_headers_in_responses? boolean
---@field http1_ignore_invalid_headers_in_responses? boolean
---@field http1_allow_spaces_after_header_name_in_responses? boolean
---@field http2_initial_stream_window_size? integer
---@field http2_initial_connection_window_size? integer
---@field http2_adaptive_window? boolean
---@field http2_max_frame_size? integer
---@field http2_max_header_list_size? integer
---@field http2_keep_alive_interval? integer
---@field http2_keep_alive_timeout? integer
---@field http2_keep_alive_while_idle? boolean
---@field local_address? string
---@field interface? string
---@field nodelay? boolean
---@field cookie_store? req.CookieStore
---@field hickory_dns? boolean
---@field https_only? boolean
---@field tls_enable_early_data? boolean
---@field quic_max_idle_timeout? integer
---@field quic_stream_receive_window? integer
---@field quic_receive_window? integer
---@field quic_send_window? integer
---@field quic_congestion_bbr? boolean
---@field h3_max_field_section_size? integer
---@field h3_send_grease? boolean
---@field dns_overrides? table<string, string[]>
---@field dns_resolver? req.Resolve
---@field unix_socket? string

---@class req.ProxyMatcher
---@field url string
---@field no_proxy? string[]

---@class req.Certificate
---@field der string

---@class req.CertificateRevocationList
---@field der string

---@class req.Identity
---@field cert string
---@field key? string

---@class req.RedirectPolicy
---@field max_redirects? integer
---@field strict? boolean
---@field end_to_end? boolean -- Preserve headers on redirects

---@class req.RetryBuilder
---@field max_retries? integer
---@field retry_interval? integer|fun(attempt: integer): integer
---@field retry_condition? fun(response: req.Response): boolean

---@class req.Client
---@field opts req.ClientOptions
--- Methods
---@field new fun(self, opts?: req.ClientOptions): req.Client
---@field request fun(self, method: req.HttpMethod, url: string, opts?: req.RequestOptions): req.Request
---@field get fun(self, url: string, opts?: req.RequestOptions): req.Request
---@field put fun(self, url: string, opts?: req.RequestOptions): req.Request
---@field patch fun(self, url: string, opts?: req.RequestOptions): req.Request
---@field delete fun(self, url: string, opts?: req.RequestOptions): req.Request
---@field head fun(self, url: string, opts?: req.RequestOptions): req.Request
---@field options fun(self, url: string, opts?: req.RequestOptions): req.Request

-- ---------------------------------------------------------------------------- --
--                              Request & Response                              --
-- ---------------------------------------------------------------------------- --

---@class req.RequestOptions: req.ClientOptions
---@field headers? table<string, req.HeaderValue>     -- headers override/extend
---@field query? req.QueryParams                      -- query params (?a=1&b=2)
---@field body? string                                -- raw body (already encoded)
---@field json? any                                   -- lua value to encode as JSON
---@field timeout? integer                            -- Request timeout in seconds
---@field form? table<string, req.QueryScalar|req.QueryScalar[]>

---@class req.Request
---@field client req.Client
---@field method req.HttpMethod
---@field url string
---@field opts req.RequestOptions
---@field headers table<string, req.HeaderValue>
---@field query? req.QueryParams
---@field body? string
--- Methods
---@field header fun(self: req.Request, k: string, v: req.HeaderValue): req.Request
---@field json fun(self: req.Request, tbl: table): req.Request
---@field timeout fun(self: req.Request, ms: integer): req.Request
---@field send fun(self: req.Request): req.Response
---@field send_safe fun(self: req.Request): boolean, req.Response

---@class req.Response
---@field status integer
---@field headers table<string, string>
---@field body string
--- Methods
---@field json fun(self: req.Response): table
---@field text fun(self: req.Response): string
---@field bytes fun(self: req.Response): string
