# Hospital module and source matrix

New compatibility UI: `/hospital/workspace/` with `?view=` below. Existing static JSP routes remain generated and linked; after an expanded-workspace session they hand off to its shared persisted state. The original 18-page conversion and its 38 tests are preserved. Backend service/schema test coverage is separate from UI coverage.

| Module | Workspace view and state transitions | Original native source / new additions |
|---|---|---|
| Home | search and reviews, detail links | MainController, main.jsp; new responsive source layout |
| Search/detail/location | search by hospital/department/address, rating sort, manual coordinate distance, detail | HpListController/HpListServiceImpl; mapper allowlist and search fix |
| Accounts/roles | register, duplicate check, login/logout, expiry, local outbox, one-use reset, member/admin | MemberController/MemberServiceImpl; new PasswordHash, token-reset controller/mapper, native account JSP |
| Booking | hospital/department/date/slot/summary → booking → own list → cancel/refund | ReservServiceImpl; hospital/member locks, strict slots and retry-safe charge/cancel |
| Past visits/reviews | owned completed visit → four scores/comment → aggregate → moderation | RateServiceImpl; completed-visit lock, score bounds and transaction |
| Favorites | detail → add → own list → remove | MypageController and existing FAV mapper |
| Profile/avatar | personal fields, image select/size/type failure, replace/remove | MypageController; session ID/IDX binding, image decode/size validation |
| Points | synthetic charge → idempotent ledger → booking/cancel balance | New synthetic ledger; native client credits rejected until verified provider adapter exists |
| Withdrawal | password recheck → pending-booking policy → deactivate/logout | Both native delete paths share MemberService policy |
| Notice/attachments | admin create/edit/delete, text attachment → user list/download | Original Notice/AdminNotice and FileUtils; bounded storage/download paths |
| FAQ | admin CRUD → searchable user list | Faq/AdminFaq controllers |
| Qna | owner CRUD → admin answer/edit/remove → owner view | Qna/AdminQna; server-owned inquiry check |
| Administration | role-protected reservations, member activation, review edit/delete, filters, audit | Original AdminController + safer exact reservation transitions; catalog controller/mapper/JSP are new |
| Guides/catalog | task-specific guide links; hospital create/edit/delete with active-booking guard | Original GuideController; new HospitalCatalogController and catalog mapper |

`portfolio-demo/control-coverage.json` maps workspace commands to test files. `native-client/route-inventory.json` lists original/native controller route declarations. `local-db/mapper-inventory.json` ties the newly derived local schema to mapper tables/sequences.

Known verification boundaries: no browser render, accessibility visual inspection, Oracle connection, container deployment, real mail, Kakao, map provider, or payment. Synthetic state is not a server authorization boundary. Native tests cover the highest-risk original services and statements, not a complete security certification of every legacy template or dependency. `NATIVE-RUNBOOK.md` explains the actual native path and explicit prerequisites.
