package hp.common.security;
import javax.servlet.*;import javax.servlet.http.*;import java.io.IOException;import java.security.SecureRandom;import java.util.Base64;import java.util.Arrays;import java.util.HashSet;import java.util.Set;
/** Native MVC boundary. No URL-name-only role checks inside the demo are trusted here. */
public class RequestSecurityFilter implements Filter {
 private static final Set<String> WRITE=new HashSet<String>(Arrays.asList("register","login","logout","sendMail","newPWD","kakaoLogin","delete","Rating","Reservation","CancelReserv","InsertFav","DelFavHp","updateUserInfo","InsertImg","DeleteImg","paymentPoint","AdminMultiModify","write","insert","update","modify","deleteNotice","insertNotice","updateNotice","deleteFaq","insertFaq","updateFaq","deleteQna","insertQna","updateQna","admindelete","save","remove"));
 public void init(FilterConfig c){} public void destroy(){}
 public void doFilter(ServletRequest in,ServletResponse out,FilterChain chain)throws IOException,ServletException{
  in.setCharacterEncoding("UTF-8");
  HttpServletRequest r=(HttpServletRequest)in;HttpServletResponse w=(HttpServletResponse)out;String p=r.getRequestURI().substring(r.getContextPath().length());
  w.setHeader("X-Content-Type-Options","nosniff");w.setHeader("X-Frame-Options","DENY");
  if(p.matches("/(css|js|img|demo|vendor)/.*")){chain.doFilter(in,out);return;}
  HttpSession s=r.getSession();String token=(String)s.getAttribute("CSRF");if(token==null){byte[] b=new byte[32];new SecureRandom().nextBytes(b);token=Base64.getUrlEncoder().withoutPadding().encodeToString(b);s.setAttribute("CSRF",token);}w.setHeader("X-CSRF-Token",token);w.addHeader("Set-Cookie","DRHER_CSRF="+token+"; Path="+r.getContextPath()+"; SameSite=Strict"+(r.isSecure()?"; Secure":""));
  if(p.equals("/api/session")){w.setContentType("application/json;charset=UTF-8");w.getWriter().write("{\"authenticated\":"+(s.getAttribute("ID")!=null)+",\"csrf\":\""+token+"\"}");return;}
  boolean admin=p.startsWith("/admin")||p.contains("Admin")||p.matches("/member/(list|list2|info)");
  boolean privatePath=admin||p.startsWith("/mypage/")||p.startsWith("/rate/")||p.startsWith("/qna/")||p.matches("/reserv/(Reservation|CancelReserv|My.*)")||p.equals("/member/delete");
  if(privatePath&&s.getAttribute("ID")==null){w.sendError(401,"Authentication required");return;}if(admin&&!"admin".equals(s.getAttribute("ID"))){w.sendError(403,"Administrator required");return;}
  String last=p.substring(p.lastIndexOf('/')+1);boolean write=WRITE.contains(last)&&!(last.equals("register")&&r.getMethod().equals("GET"));
  if(write&&!r.getMethod().equals("POST")){w.sendError(405,"POST required");return;}
  if(!r.getMethod().equals("GET")&&!r.getMethod().equals("HEAD")){String supplied=r.getHeader("X-CSRF-Token");if(supplied==null)supplied=r.getParameter("_csrf");if(!token.equals(supplied)){w.sendError(403,"Invalid CSRF token");return;}}
  chain.doFilter(in,out);
 }
}
