## [1.2.0] - 2026-03-24
- Patch activesupport to 7.2.3.1.
  - Fix possible ReDoS vulnerability in `number_to_delimited`.
  - Fix possible XSS vulnerability in `ActiveSupport::SafeBuffer#%`.
- Add SECURITY.md.
- Add README.md link to the security policy.
- Add RSpec coverage for loading remote error definitions.
- Add RuboCop configuration and clean up lint issues.
- Improve remote YAML loading safety.
## [1.1.6] - 2025-07-18
- Fix readme typo.
## [1.1.5] - 2025-07-16
- Update development_dependency.
- Update require `active_support/concern` instead of `active_support/all`.
- Optimize rspec test.
- Update CI to use Ruby 3.4.5.
- Fix Deserialization of untrusted data [CWE-502](https://cwe.mitre.org/data/definitions/502.html) by using `YAML.safe_load`.
## [1.1.4] - 2023-11-06
- Update Gemfile.lock, fix Active Support security issue [CVE-2023-38037](https://github.com/advisories/GHSA-cr5q-6q9f-rq6q).
## [1.1.3] - 2023-05-18
- Add gitlab templates.
## [1.1.2] - 2023-03-30
- Update Gemfile.lock, fix Active Support security issue [CVE-2023-28120](https://github.com/advisories/GHSA-pj73-v5mw-pm9j).
## [1.1.1] - 2023-02-10
- Update Gemfile.lock, fix Active Support security issue [CVE-2023-22796](https://github.com/advisories/GHSA-j6gc-792m-qgm2).
## [1.1.0] - 2022-09-01
- Add common helpers.
