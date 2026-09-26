# Native and synthetic execution

The two execution paths are intentionally explicit. No production-ready claim follows from these tests.

- `portfolio-demo`: generated original JSP pages plus a newly authored complete-module compatibility workspace. Data is synthetic and browser-local. The new UI reuses the original route vocabulary, column names and ported booking/review/search service logic. It is not recovered original frontend code. Demo passwords are only synthetic local data.
- Native: the original Spring MVC 4 / MyBatis / Tiles WAR renders server-backed JSPs against an operator-configured Oracle datasource. `native-client/http.mjs` calls actual native JSON endpoints with cookies and CSRF; it does not import fixtures. The static workspace has **no HTTP toggle** and does not pretend to be connected. Use native JSP routes for native workflows.

## Reproduce without operational data

1. Use JDK 8 or 17 and Maven 3.9. `mvn -Dmaven.repo.local=/tmp/hospital-m2 clean test package` compiles the real source and runs tests. Tomcat 9 is the intended javax.servlet container; do not use Jakarta/Tomcat 10 without a reviewed migration.
2. Create a disposable, empty Oracle schema yourself. Review `local-db/oracle-local.sql` and apply only there. This DDL is newly derived from mappers, not recovered production DDL and not an upgrade migration. No DB was created or contacted during delivery.
3. Configure the environment values named in `.env.native.example`. No real values are supplied. Generate local passwords with `hp.common.security.PasswordHash.hash`; the result uses PBKDF2-HMAC-SHA256, 600,000 iterations and random salt. The optional seed-account template is synthetic only. Historic MD5 hashes are intentionally rejected and require reset; no silent plaintext/MD5 fallback exists. Widening an existing PWD column and adopting reset-table/unique constraints requires a separate migration review.
4. Deploy `target/hospital.war` to the local container only when you choose to run it. Context path is `/hospital`. This task did not deploy it. Missing datasource configuration fails visibly.
5. Native login: `/hospital/member/loginForm`; register: `/hospital/member/register`; reset: `/hospital/member/resetForm`. `DRHER_LOCAL_OUTBOX` enables local file delivery only; it sends no mail. `/api/password/request` and `/api/password/confirm` persist one-use, 15-minute hashed reset tokens. Real email/Kakao/payment adapters remain external prerequisites.
6. Native catalog: `/hospital/admin/catalog` (admin only). This is new source using the existing HOSPITAL table. Other native menus retain their original Tiles routes. Global `src/main/webapp/css/ui.css` styles the main, list, detail, form and admin surfaces.

## Native contracts

| Workflow | Native endpoint / implementation |
|---|---|
| Session / CSRF | GET `/api/session`, filter issues CSRF token, unsafe methods require it |
| Search / details | POST `/hplist/selectHpList`, page `/hplist/HpDetail`; mapper IDs are allowlisted; admin query needs server-set authority |
| Slots / booking | POST `/reserv/ReservDate`, `/reserv/Reservation`; original service locks hospital/member, validates slot/department, debits atomically |
| Cancel / history | POST `/reserv/CancelReserv`, pages `/reserv/MyReserv`, `/reserv/MyPastReserv`; repeat cancellation never repeats a refund |
| Review | POST `/rate/Rating`, `/rate/RatingList`; session identity, owned completed visit lock, score bounds, one review and state write in one transaction |
| Favorites / profile | `/mypage/InsertFav`, `/mypage/DelFavHp`, `/mypage/selectUserInfo`, `/mypage/updateUserInfo`; session-bound ID/IDX |
| Avatar | `/mypage/InsertImg`, `/mypage/DeleteImg`; PNG/JPEG decoding and size bounds |
| Withdrawal | `/member/delete` and `/mypage/delete`; current password, session identity, upcoming-reservation policy |
| Notice / FAQ / inquiry | original `/notice`, `/faq`, `/qna`, `/admin/notice`, `/admin/faq`, `/admin/qna` controller routes; personal inquiry reads and writes verify owned question |
| Administrative reservations | `/admin/AdminMultiModify`; exact reservation lock, explicit state transitions, cancellation refund inside transaction |
| Catalog | GET `/admin/catalog`, POST `/admin/catalog/save`, `/admin/catalog/remove`, `/admin/catalog/list` |
| Payment | `/mypage/paymentPoint` rejects client-supplied credits. No real processor is configured; the synthetic workspace has its own ledger |

The HTTP client only exposes the native JSON subset (search, slots, booking, profile, favorites and reset). HTML/redirect routes require native page navigation; an HTML response to a JSON request is an error, never a fixture fallback.

## Evidence and limits

The 14 native tests compile actual source and execute original MyBatis booking/cancellation/review statements on an isolated Oracle-mode H2 database. Tests exercise transaction rollback, duplicate retries, final-slot concurrency, ownership, scores, password handling, role/method/CSRF boundaries and query allowlists. They also boot the actual parent/Dispatcher XML configuration in loopback Tomcat, compile and serve the registration JSP, and verify Korean form data persists correctly. H2 is a test dependency only; the production datasource stays Oracle. Existing Oracle schema compatibility, external provider behavior and operational deployment remain unverified. Browser control/screenshots were forbidden, so these checks are not visual approval.

Maven maintenance: retired HTTP repositories replaced by Maven Central HTTPS; unused EgovProperty dependency removed after no source/config references; Oracle driver moved to available ojdbc8 19.3; Servlet API aligned with Tomcat 9 while retaining the existing 3.0 web.xml; WAR/Surefire plugins and JUnit updated for reproducible local builds. Spring/Tiles/MyBatis were not migrated. These old frameworks still need a separate support/security maintenance decision before public operation.

Generated `target/` output is excluded from Git. Source, tests and local setup examples are the handoff.

Native context verification now also boots the actual parent/Dispatcher XML configuration and an ephemeral loopback Tomcat instance against disposable H2. The registration JSP compiles and serves; a Korean form POST persists correctly. Password reset and catalog transactions reside in parent-context services, with proxy/rollback proof. This is not a browser layout check or operational Oracle proof.
