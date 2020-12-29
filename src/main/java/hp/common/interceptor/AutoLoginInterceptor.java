package hp.common.interceptor;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import org.springframework.web.util.WebUtils;

import hp.Final.service.MemberService;

public class AutoLoginInterceptor extends HandlerInterceptorAdapter{

	 @Resource(name = "memberService")
	 MemberService memberService;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception 
    {           
        // session 객체를 가져옴
        HttpSession session = request.getSession();
      
        // login처리를 담당하는 사용자 정보를 담고 있는 객체를 가져옴
        Object obj = session.getAttribute("ID");

        // 로그인된 세션이 없는 경우
        if ( obj == null )
        { 
            // 만들어 논 쿠키를 꺼내온다.
            Cookie autoLogin = WebUtils.getCookie(request, "autoLogin");
            

            // 쿠키가 존재하는 경우(이전에 로그인때 생성된 쿠키가 존재한다는 것)
            if ( autoLogin != null )
            { 
            	// autoLogin의 값을 꺼내오고 -> 즉, 저장해논 세션Id를 꺼내오고
            	String SESSIONKEY = autoLogin.getValue();
            	
            	Map<String, Object> chk = memberService.checkUserWithSessionKey(SESSIONKEY);
            	
            	if(chk != null)
            	{
            		 session.setAttribute("ID", chk.get("ID").toString());
                     
                     return true;
            	}else {
            		response.sendRedirect("/login");
            		return false;
            	}
            	
              }
            
            // 이제 아래는 로그인도 안되있고 쿠키도 존재하지 않는 경우니까 다시 로그인 폼으로 돌려보내면 된다.
            // 로그인이 안되어 있는 상태임으로 로그인 폼으로 다시 돌려보냄(redirect)
            

            return true; 
      

        }

        return true;

    }

    
    //preHandel -> controller 이벤트 호출전
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception 
    {
        super.postHandle(request, response, handler, modelAndView);
    }
}