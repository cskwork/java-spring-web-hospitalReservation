package hp.sk.controller;

import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import hp.Final.service.MemberService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/member")
public class MemberController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource private hp.common.controller.PasswordResetController passwordReset;
 @Resource(name = "memberService") private MemberService memberService;

	// 01 전체 회원 목록
	@RequestMapping("/list")
	public String openBoardList() throws Exception {
		return "sk/member/listAll";
	}

	@RequestMapping("/list2")
	public String memberAll(CommandMap commandMap, Model model) throws Exception {
		List<Map<String, Object>> memberList = memberService.selectMemberList(commandMap.getMap());

		model.addAttribute("list", memberList);

		// AJAX count
		if (memberList.size() > 0)
			model.addAttribute("TOTAL", memberList.get(0).get("TOTAL_COUNT"));
		else
			model.addAttribute("TOTAL", 0);

		return "jsonView";
	}

	// 01 회원 정보
	@RequestMapping("/info")
	public String memberView(CommandMap commandMap, Model model) throws Exception {
		Map<String, Object> memberMap = memberService.viewMember(commandMap.getMap());

		model.addAttribute("view", memberMap.get("map"));
		model.addAttribute("list", memberMap.get("list"));

		return "sk/member/info";
	}

	/* CREATE */
	// 02_01 회원 등록 페이지로 이동
	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public String memberForm(Model model) throws Exception {
        model.addAttribute("authMode","register");return "compat/account";
	}

	// 02_02 회원 가입 처리
	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public String memberWrite(CommandMap commandMap, RedirectAttributes rttr) throws Exception {
		memberService.insertMember(commandMap.getMap(), rttr);

		return "redirect:/member/loginForm";
	}

	/* DELETE */
	// 04 회원 탈퇴
	@RequestMapping("/delete")
	public String deleteMember(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		model.addAttribute("check", (boolean) memberService.deleteMember(commandMap.getMap(), session));

		return "jsonView";
	}

	// 02_03 회원가입시 ID 중복 확인
	// 회원가입시 아이디 중폭체크.
	@RequestMapping("/checkId")
	public String checkId(CommandMap commandMap, Model model) throws Exception {
		model.addAttribute("checkId", memberService.checkId(commandMap.getMap()));

		return "jsonView";
	}

	@RequestMapping("/sendMail")
	private String sendMail(CommandMap commandMap, Model model, RedirectAttributes rttr) throws Exception {
		passwordReset.request(String.valueOf(commandMap.get("ID")));
        model.addAttribute("message","If the account exists, a one-time link has been sent to the configured local outbox.");return "jsonView";
	}

	// 05_01 로그인 페이지로 이동
	@RequestMapping("/loginForm")
	public String loginForm(Model model) throws Exception {
		model.addAttribute("authMode","login");return "compat/account";
	}

    @RequestMapping(value="/resetForm",method=RequestMethod.GET)
    public String resetForm(Model model){model.addAttribute("authMode","reset");return "compat/account";}

	// 05_02 로그인 처리
	@RequestMapping("/login")
	public String login(CommandMap commandMap, Model model, javax.servlet.http.HttpServletRequest request, HttpSession session, HttpServletResponse response,
			RedirectAttributes rttr) throws Exception {
		session.invalidate();
        String destination=memberService.login(commandMap.getMap(), request.getSession(true), model, response, rttr);
        return "mainForm".equals(destination)?"redirect:/main":destination;
	}

	// 06 로그아웃
	@RequestMapping("/logout")
	public String logout(Model model, HttpSession session) throws Exception {
		session.invalidate();

		return "redirect:/main";
	}

	// 07 카카오 로그인
	@RequestMapping("/kakaoLogin")
	public String kakaoLogin(CommandMap commandMap, Model model, HttpSession session, HttpServletResponse response, RedirectAttributes rttr) throws Exception {
			return memberService.kakaoLogin(commandMap.getMap(), session, model, response, rttr);
	}

	// 비밀번호 변경
	@RequestMapping("/newPWD")
	public String newPWD(CommandMap commandMap, RedirectAttributes rttr, HttpSession session) throws Exception {
		passwordReset.confirm(String.valueOf(commandMap.get("TOKEN")),String.valueOf(commandMap.get("PWD")),session);

		return "redirect:/member/loginForm";
	}
}