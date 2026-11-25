# VulDB API Ruby Examples

[![Language: Ruby](https://img.shields.io/badge/Language-Ruby-CC342D?logo=ruby&logoColor=white)](https://www.ruby-lang.org/)
[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![VulDB API](https://img.shields.io/badge/VulDB-API-blue)](https://vuldb.com/kb/api)

Ruby example implementation for accessing the [VulDB API](https://vuldb.com/kb/api) and retrieving vulnerability intelligence directly from [VulDB](https://vuldb.com/).

VulDB provides comprehensive vulnerability information, including technical descriptions, risk assessments, CVE references, exploit intelligence, and mitigation information. Its API enables automated access to vulnerability data for security tools, vulnerability management platforms, SIEM and SOAR solutions, and custom integrations.

This repository provides a lightweight starting point for developers who want to integrate VulDB into Ruby applications or automated security workflows.

## Table of Contents

- [Features](#features)
- [Repository Structure](#repository-structure)
- [Requirements](#requirements)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Usage Examples](#usage-examples)
- [API Communication](#api-communication)
- [API Response](#api-response)
- [API Credits](#api-credits)
- [Troubleshooting](#troubleshooting)
- [Security and Production Recommendations](#security-and-production-recommendations)
- [Contributing](#contributing)
- [License](#license)
- [Resources and Support](#resources-and-support)

## Features

- Retrieve recently published VulDB entries.
- Retrieve an individual vulnerability by its VulDB ID.
- Search for vulnerabilities by CVE identifier.
- Request basic or extended vulnerability information.
- Authenticate with a personal VulDB API key via an HTTP request header.
- Communicate with the API over HTTPS.
- Display the API response directly in the terminal.
- Use Ruby's standard/default libraries without additional application frameworks.

## Repository Structure

| File | Description |
| --- | --- |
| [`VulDBApiDemoRuby.rb`](VulDBApiDemoRuby.rb) | Standalone Ruby demonstration of authenticated VulDB API requests. |
| [`README.md`](README.md) | Documentation, configuration instructions, and usage examples. |
| [`LICENSE`](LICENSE) | GNU General Public License v3.0. |

## Requirements

- A supported Ruby installation with the following libraries available:
  - `net/http` — HTTP and HTTPS communication.
  - `uri` — URI handling.
  - `json` — JSON processing (imported by the demo; available for extensions).
- A [VulDB account](https://vuldb.com/) and a valid personal API key.
- Internet access to `vuldb.com` over HTTPS (TCP port 443).
- Git, if cloning the repository.

No additional third-party dependencies are required by the demo. If your Ruby distribution does not include one of the libraries, install the corresponding Ruby gem. The repository does not specify a minimum Ruby version; a currently maintained release is recommended.

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/vuldb/vuldb-api-ruby-examples.git
cd vuldb-api-ruby-examples
```

Alternatively, download the repository using **Code → Download ZIP** on GitHub.

### 2. Verify Ruby and Dependencies

```bash
ruby --version
ruby -rnet/http -ruri -rjson -e 'puts "Dependencies available"'
```

### 3. Configure Your API Key

Log in to [VulDB](https://vuldb.com/) and retrieve your personal API key from your user profile.

Open [`VulDBApiDemoRuby.rb`](VulDBApiDemoRuby.rb) and locate the `personal_api_key` assignment. The distributed script leaves this value empty. For safer local configuration, replace that assignment with:

```ruby
personal_api_key = ENV.fetch("VULDB_API_KEY")
```

Provide the key through your environment before running the script. For example, in Bash:

```bash
read -rsp 'VulDB API key: ' VULDB_API_KEY; echo
export VULDB_API_KEY
```

> [!IMPORTANT]
> Environment variable support requires the one-line modification above. The original script expects the API key to be configured directly in the source file. Never commit a real API key to Git or include it in shared logs or screenshots.

### 4. Run the Example

```bash
ruby VulDBApiDemoRuby.rb
```

By default, the script requests the five most recent vulnerability entries with basic details and writes the response to standard output.

## Configuration

The request is configured through local variables inside the `VulDBApiDemo.run` method. The supplied script does not accept command-line options.

| Variable | Default | Description |
| --- | --- | --- |
| `personal_api_key` | `""` | Personal API key used for authentication. |
| `user_agent` | `"VulDB API Advanced Ruby Demo Agent"` | HTTP client identification. |
| `recent` | `"5"` | Number of recent entries to request. |
| `details` | `"0"` | `"0"` for basic results; `"1"` for extended results. |
| `id` | `nil` | VulDB entry identifier for a direct lookup. |
| `cve` | `nil` | CVE identifier passed to the API search operation. |

Query selection is automatic:

1. If `cve` is not `nil`, the script performs a search query.
2. Otherwise, if `id` is not `nil`, it requests that VulDB entry.
3. If both are `nil`, it retrieves recent entries.

If both `id` and `cve` are configured, the CVE search takes precedence. The `details` setting applies to every query mode.

## Usage Examples

For each example, adjust the four request variables inside `VulDBApiDemoRuby.rb`, save the file, and execute `ruby VulDBApiDemoRuby.rb`.

### Retrieve Recent Vulnerabilities

Request the ten latest entries:

```ruby
recent = "10"
details = "0"
id = nil
cve = nil
```

Equivalent POST parameters:

```text
recent=10&details=0
```

### Retrieve a Vulnerability by VulDB ID

Request VulDB entry [67685](https://vuldb.com/id/67685):

```ruby
recent = "5"
details = "0"
id = "67685"
cve = nil
```

Equivalent POST parameters:

```text
id=67685&details=0
```

### Search for a CVE Identifier

Search for CVE-2014-6271:

```ruby
recent = "5"
details = "0"
id = nil
cve = "CVE-2014-6271"
```

Equivalent POST parameters:

```text
search=CVE-2014-6271&details=0
```

### Retrieve Extended Vulnerability Details

Enable additional data points for a specific vulnerability:

```ruby
recent = "5"
details = "1"
id = "67685"
cve = nil
```

Equivalent POST parameters:

```text
id=67685&details=1
```

Extended results depend on your account permissions and API credit balance. See the [Data Points documentation](https://vuldb.com/kb/datapoints) for available fields.

## API Communication

| Property | Value |
| --- | --- |
| Endpoint used by the demo | `https://vuldb.com/api` |
| HTTP method | `POST` |
| Authentication header | `X-VulDB-ApiKey` |
| Client identification | `User-Agent` |
| Request body | URL-encoded form parameters |
| Default response format | JSON |
| Transport | HTTPS |

The demo selects the request parameters, creates an HTTPS connection using `Net::HTTP`, attaches the authentication header, submits the POST request, and displays the response body when the HTTP status is `200`.

The [official API documentation](https://vuldb.com/kb/api) describes additional request types, filtering, sorting, pagination, API version selection, and cyber threat intelligence queries. These are not implemented as separate options in the supplied demonstration.

## API Response

The JSON response is organized into three main sections:

| Section | Description |
| --- | --- |
| `response` | Processing status, API version, result count, and credit information. |
| `request` | Information about the processed query. |
| `result` | Array of vulnerability records returned for the query. |

The supplied script prints the raw response body. Although it imports `json`, it does not currently deserialize the JSON data.

### Processing Results in Ruby

For programmatic processing, the following snippet can be used in place of the existing HTTP-200 response-printing block (inside the `if response.code.to_i == 200` branch):

```ruby
data = JSON.parse(response.body)
metadata = data.fetch("response")

case metadata.fetch("status").to_s
when "200"
  Array(data["result"]).each do |item|
    entry = item.fetch("entry", {})
    cve_id = item.dig("source", "cve", "id")

    puts "#{entry['id']}: #{entry['title']}"
    puts "CVE: #{cve_id}" if cve_id
  end
when "204"
  puts "No matching vulnerabilities found."
else
  warn "VulDB API error #{metadata['status']}: #{metadata['error']}"
end
```

This is an optional extension, not part of the original demonstration. Consult the API reference for the complete response schema and available data fields.

## API Credits

VulDB applies API credit limits based on the account and license. Basic vulnerability lookups generally use one credit per request. Full-detail queries typically charge per returned vulnerability, subject to the applicable permissions and credit rules. Even unsuccessful requests can consume credits.

Check `response.consumption` and `response.remaining` when available to monitor usage. Start with small queries and `details = "0"` during development.

Further information: [API Credits](https://vuldb.com/kb/apicredits) and [API Documentation](https://vuldb.com/kb/api).

## Troubleshooting

The demo prints HTTP status information for non-200 responses and catches exceptions during execution. A successful HTTP request does not necessarily imply a successful API operation: inspect the JSON field `response.status` as well.

| API status | Meaning / suggested action |
| --- | --- |
| `200` | Query completed with results. |
| `204` | No matching records. Verify the search input. |
| `400` | Invalid query data. Review the configured parameters. |
| `401` | Missing or invalid API key. Verify the credentials. |
| `402` | The account license does not authorize the request. |
| `403` | Credit or rate limit reached. Check the remaining allowance and reset conditions. |
| `405` | Unsupported request type. Consult the API reference. |
| `409` | Request blocked due to suspected abuse. Stop requests and review the account status. |

Other common problems:

- `LoadError`: verify the required Ruby libraries are installed.
- TLS or connection errors: verify network connectivity, proxy settings, and trusted CA certificates. Do not disable TLS certificate verification.
- Missing extended data: review the `details` setting, license permissions, and available data points.
- Unexpected response format: inspect the body and API status before attempting JSON parsing.

## Security and Production Recommendations

The repository contains demonstration code, not a production-ready SDK. When building a production integration:

- Load API credentials from a secret manager or protected environment variable.
- Keep TLS certificate verification enabled.
- Use `request.set_form_data` or `URI.encode_www_form` when constructing requests with arbitrary search text rather than manually interpolating query values.
- Set explicit connection and read timeouts; use bounded retries with backoff for transient failures, taking credit consumption into account.
- Check both the HTTP status and the API-specific status before processing results.
- Handle empty results, malformed JSON, and optional response fields.
- Specify the API major version supported by your parser (for example, `version=3`) for predictable response compatibility.
- Monitor credit consumption and observe account-specific request limits.
- Avoid exposing API keys or restricted vulnerability data in logs.

The original demo does not implement explicit timeouts, retries, pagination, API version pinning, or API-level status handling. These should be added as appropriate to the consuming application.

## Contributing

Contributions, corrections, and improvements are welcome. To propose a change:

1. Fork the repository.
2. Create a branch for your changes.
3. Verify your modifications locally, without committing credentials.
4. Submit a pull request describing the changes.

Report reproducible problems through [GitHub Issues](https://github.com/vuldb/vuldb-api-ruby-examples/issues). Include the Ruby version, a description of the behavior, and sanitized error information.

## License

The example source code is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for the full license text.

The open-source license applies to the example code; access to and use of VulDB data remain subject to the applicable [VulDB terms and conditions](https://vuldb.com/kb/terms) and account license. Refer to the official service terms for details.

## Resources and Support

| Resource | Link |
| --- | --- |
| VulDB website | <https://vuldb.com/> |
| API documentation | <https://vuldb.com/kb/api> |
| API data points | <https://vuldb.com/kb/datapoints> |
| API credits | <https://vuldb.com/kb/apicredits> |
| Knowledge base | <https://vuldb.com/kb> |
| Official GitHub repositories | <https://github.com/vuldb> |
| Ruby documentation | <https://www.ruby-lang.org/en/documentation/> |
| Support information | <https://vuldb.com/kb/support> |
| Email support | [support@vuldb.com](mailto:support@vuldb.com) |

---

[VulDB](https://vuldb.com/) — Vulnerability Management and Cyber Threat Intelligence
