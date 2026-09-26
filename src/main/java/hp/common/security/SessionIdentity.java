package hp.common.security;
import javax.servlet.http.HttpSession;
import java.util.Map;
public final class SessionIdentity {
 public static void bind(Map<String,Object> map,HttpSession session){if(session==null||session.getAttribute("ID")==null||session.getAttribute("IDX")==null)throw new SecurityException("Authentication required");map.put("ID",session.getAttribute("ID"));map.put("IDX",session.getAttribute("IDX"));}
 public static void admin(HttpSession session){if(session==null||!"admin".equals(session.getAttribute("ID")))throw new SecurityException("Administrator required");}
 private SessionIdentity(){}
}
