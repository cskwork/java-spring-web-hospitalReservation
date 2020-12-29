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

	@Resource(name = "memberService")
	private MemberService memberService;

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
	public String memberForm() throws Exception {
		return "/member/register";
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
		try {
			// SMTP 서버 정보를 설정한다.
			Properties props = new Properties();
			props.put("mail.smtp.host", "smtp.naver.com");
			props.put("mail.smtp.port", 465);
			props.put("mail.smtp.auth", "true");
		    props.put("mail.smtp.ssl.enable", "true");
		    props.put("mail.smtp.ssl.trust", "smtp.naver.com");

			// 접속 아이디 비밀번호 설정
			MimeMessage message = new MimeMessage(Session.getDefaultInstance(props, new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication("csk917@naver.com", "hot6isgood");
				}
			}));
			
			String joinCode = (String) commandMap.getMap().get("joinCode");

			// 이메일 전송 내용
			message.setFrom(new InternetAddress("csk917@naver.com"));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress((String) commandMap.getMap().get("ID"))); // 받는사람 이메일

			message.setContent("회원가입 승인번호는 " + joinCode + "입니다.<br/><br/>", "text/html; charset=UTF-8"); // 메일 내용
			message.setSubject("회원가입 승인 번호 입니다."); // 메일 제목을 입력

			Transport.send(message); //// 전송

			// 메일에 도착한 인증코드와 비교하는 기능이 다른 function에 있기 때문에 파라미터를 리턴한다.
			model.addAttribute("joinCode", joinCode);
		} catch (AddressException e) {
			rttr.addFlashAttribute("msg", "이메일 주소에 오류가 있습니다.");

			e.printStackTrace();
		} catch (MessagingException e) {
			e.printStackTrace();
		}

		return "jsonView";
	}

	// 05_01 로그인 페이지로 이동
	@RequestMapping("/loginForm")
	public String loginForm(Model model) throws Exception {
		model.addAttribute("body", "loginForm");

		return "mainForm";
	}

	// 05_02 로그인 처리
	@RequestMapping("/login")
	public String login(CommandMap commandMap, Model model, HttpSession session, HttpServletResponse response,
			RedirectAttributes rttr) throws Exception {
		return memberService.login(commandMap.getMap(), session, model, response, rttr);
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
	public String newPWD(CommandMap commandMap, RedirectAttributes rttr) throws Exception {
		memberService.newPWD(commandMap.getMap(), rttr);

		return "redirect:/member/loginForm";
	}
}