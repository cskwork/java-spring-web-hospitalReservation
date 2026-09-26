package hp.common.resolver;

import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import hp.common.common.CommandMap;

public class CustomMapArgumentResolver implements HandlerMethodArgumentResolver{
	@Override
	public boolean supportsParameter(MethodParameter parameter) {
		return CommandMap.class.isAssignableFrom(parameter.getParameterType());
	}

	@Override
	public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
		CommandMap commandMap = new CommandMap();
		
		HttpServletRequest request = (HttpServletRequest) webRequest.getNativeRequest();
		Enumeration<?> enumeration = request.getParameterNames();
		
		String key = null;
		String[] values = null;
		
		while(enumeration.hasMoreElements()){
			key = (String) enumeration.nextElement();
			values = request.getParameterValues(key);
	
			if(values != null){
				if(java.util.Arrays.asList("NAME","ADDR","HOSP","H_COMM","DOC_COMM","TITLE","CONTENT","Q","A","COMM").contains(key)) {
                    for(int i=0;i<values.length;i++){if(values[i].length()>4000)throw new IllegalArgumentException("Text is too long");values[i]=org.springframework.web.util.HtmlUtils.htmlEscape(values[i]);}
                }
                commandMap.put(key, (values.length > 1) ? values:values[0] );
			}
		}
		String route=request.getRequestURI().substring(request.getContextPath().length());
        if(route.startsWith("/mypage/")||route.startsWith("/reserv/")||route.startsWith("/rate/")||route.startsWith("/qna/")) {
            javax.servlet.http.HttpSession session=request.getSession(false);
            if(session!=null&&session.getAttribute("ID")!=null){commandMap.put("ID",session.getAttribute("ID")); if(route.startsWith("/mypage/"))commandMap.put("IDX",session.getAttribute("IDX"));}
        }
        commandMap.getMap().remove("RESET_VERIFIED");commandMap.getMap().remove("SERVER_ADMIN");
        return commandMap;
	}
}
