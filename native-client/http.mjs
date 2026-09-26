/** Native MVC client: original JSON/redirect endpoints, cookie session and CSRF.
 * No mock import, fixtures, automatic fallback or arbitrary cross-origin base URL. */
export function createNativeClient({origin,request=globalThis.fetch}){
 const allowed=new URL(origin);if(!['http:','https:'].includes(allowed.protocol))throw Error('HTTP origin required');let csrf;
 async function send(path,params,method='POST'){
  const url=new URL('/hospital'+path,allowed);if(url.origin!==allowed.origin)throw Error('Cross-origin request rejected');
  if(!csrf){const session=await request(new URL('/hospital/api/session',allowed),{credentials:'same-origin',redirect:'error',headers:{Accept:'application/json'}});if(!session.ok)throw Error('Session initialization failed: '+session.status);csrf=(await session.json()).csrf;if(!csrf)throw Error('Missing CSRF token');}
  const response=await request(url,{method,credentials:'same-origin',redirect:'error',headers:{Accept:'application/json','Content-Type':'application/x-www-form-urlencoded','X-CSRF-Token':csrf},...(method==='GET'?{}:{body:new URLSearchParams(params||{}).toString()})});
  const renewed=response.headers.get('X-CSRF-Token');if(renewed)csrf=renewed;if(!response.ok)throw Error('Native request failed: '+response.status);
  if(!String(response.headers.get('content-type')).includes('application/json'))throw Error('Expected native JSON response; use native page navigation for HTML routes');return response.json();
 }
 return {session:()=>send('/api/session',null,'GET'),search:p=>send('/hplist/selectHpList',p),times:p=>send('/reserv/ReservDate',p),book:p=>send('/reserv/Reservation',p),profile:()=>send('/mypage/selectUserInfo',{}),updateProfile:p=>send('/mypage/updateUserInfo',p),favorite:p=>send('/mypage/InsertFav',p),requestReset:p=>send('/api/password/request',p),confirmReset:p=>send('/api/password/confirm',p)};
}
