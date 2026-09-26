package hp.common.controller;
import javax.servlet.http.*;import java.util.*;import org.springframework.web.bind.annotation.*;import org.springframework.web.servlet.ModelAndView;
@ControllerAdvice public class NativeErrorAdvice {
 @ExceptionHandler({SecurityException.class,IllegalArgumentException.class,IllegalStateException.class})
 public ModelAndView failure(Exception e,HttpServletRequest request,HttpServletResponse response){response.setStatus(e instanceof SecurityException?403:400);ModelAndView result=new ModelAndView("compat/error");result.addObject("message",e.getMessage());return result;}
}
