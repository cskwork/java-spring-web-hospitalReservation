package hp.Final.service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
//import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import hp.Final.dao.MemberDAO;
import hp.common.security.MD5Hash;
import hp.common.util.FileUtils;

@Service("memberService")
public class MemberServiceImpl implements MemberService {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "fileUtils")
	private FileUtils fileUtils;

	@Resource(name = "ReservDAO")
 private hp.Final.dao.ReservDAO reservDAO;
 @Resource(name="MypageDAO") private hp.Final.dao.MypageDAO mypageDAO;
	@Resource(name = "memberDAO")
	private MemberDAO memberDAO;

	// 로그인
	@Override
	public String login(Map<String, Object> map, HttpSession session, Model model, HttpServletResponse response,
			RedirectAttributes rttr) throws Exception {
		// 암호 암호화
		String supplied = (String)map.remove("PWD");
		Map<String, Object> login = memberDAO.login(map);
		if(login!=null&&!hp.common.security.PasswordHash.verify(supplied,String.valueOf(login.get("PWD"))))login=null;

		// 로그인 세션 생성
		if (login != null) {
			login.remove("PWD");login.remove("ID_SESSIONK");model.addAttribute("user", login);
			session.setAttribute("IDX", login.get("IDX"));
			session.setAttribute("ID", login.get("ID"));
			session.setAttribute("NAME", login.get("NAME"));
			session.setAttribute("ADDR", login.get("ADDR"));
			session.setAttribute("ID_IMG", login.get("ID_IMG"));

			if (login.get("ID").equals("admin")) {
				return "mainForm";
			}

			// 자동 로그인 체크되어 있으면
			if (false) {
				Cookie autoLogin = new Cookie("autoLogin", session.getId());

				autoLogin.setPath("/");

				int amount = 60 * 60 * 24 * 7;
				autoLogin.setMaxAge(amount); // 단위는 (초)임으로 7일정도로 유효시간을 설정해 준다.
				// 쿠키를 적용해 준다.
				response.addCookie(autoLogin);

				String SESSIONK = session.getId();
				Date SESSIONL = new Date(System.currentTimeMillis() + (1000 * amount));

				map.put("ID", map.get("ID"));
				map.put("ID_SESSIONK", SESSIONK);
				map.put("ID_SESSIONL", SESSIONL);

				keepLogin(map);
			}
			model.addAttribute("body", "body");

			return "mainForm";
		} else { // 로그인 실패
			rttr.addFlashAttribute("msg", "비밀번호 또는 아이디를 다시 확인해주세요.");

			return "redirect:/member/loginForm";
		}
	};

	// 카카오 회원가입 및 로그인
	@Override
	public String kakaoLogin(Map<String, Object> map, HttpSession session, Model model, HttpServletResponse response,
			RedirectAttributes rttr) throws Exception {
		throw new SecurityException("Verified Kakao provider adapter is not configured");
	}

	// 자동로그인
	@Override
	public void keepLogin(Map<String, Object> map) throws Exception {
		memberDAO.keepLogin(map);
	};

	// 유효시간이 넘지 않은 세션을 가지고 있는지 체크한다.
	@Override
	public Map<String, Object> checkUserWithSessionKey(String SESSIONKEY) throws Exception {

		return null; // legacy session-ID cookies are not authentication tokens
	}

	// 회원목록
	@Override
	public List<Map<String, Object>> selectMemberList(Map<String, Object> map) throws Exception {
		List<Map<String, Object>> memberList = memberDAO.selectMemberList(map);

		return memberList;
	};

	// 회원상세보기
	@Override
	public Map<String, Object> viewMember(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> viewMember = memberDAO.viewMember(map);
		resultMap.put("map", viewMember);

		return resultMap;
	};

	// 회원가입
	@Transactional
	@Override
	public void insertMember(Map<String, Object> map, RedirectAttributes rttr) throws Exception {
		if("admin".equalsIgnoreCase(String.valueOf(map.get("ID"))))throw new SecurityException("Reserved account");
        if(!String.valueOf(map.get("ID")).matches("[A-Za-z0-9_.@-]{3,100}"))throw new IllegalArgumentException("Invalid account identifier");
        if(memberDAO.checkId(String.valueOf(map.get("ID")))!=0)throw new IllegalArgumentException("Account already exists");
        // 유저 암호 암호화 처리
		map.put("PWD", hp.common.security.PasswordHash.hash((String) map.get("PWD")));
	
		rttr.addFlashAttribute("authmsg", "가입시 사용할 이메일로 인증해주세요");
		rttr.addFlashAttribute("msg", "회원등록이 되었습니다. 로그인해주세요");
	
		memberDAO.insertMember(map); // 회원가입
	};

	// 유저 ID 중복 확인
	@Override
	public int checkId(Map<String, Object> map) throws Exception {
		String ID = "";

		if (map.get("ID") != null)
			ID = (String) map.get("ID");

		return memberDAO.checkId(ID);
	}

	// 이메일 인증확인
	@Override
	public void userAuth(Map<String, Object> map) throws Exception {
		memberDAO.userAuth(map);
	}

	// 비밀번호 변경
	@Override
	public void newPWD(Map<String, Object> map, RedirectAttributes rttr) throws Exception {
		if (!Boolean.TRUE.equals(map.remove("RESET_VERIFIED"))) throw new SecurityException("One-time reset token required");
		map.put("PWD", hp.common.security.PasswordHash.hash((String) map.get("PWD")));
		memberDAO.newPWD(map);
		
		rttr.addFlashAttribute("msg2", "비밀번호를 변경하였습니다. 다시 로그인해주세요.");
	}

	// 회원삭제
	@Transactional(rollbackFor=Exception.class)
	public boolean deleteMember(Map<String, Object> map, HttpSession session) throws Exception {
		hp.common.security.SessionIdentity.bind(map,session);
		Map<String,Object> selectMember=mypageDAO.lockMember(map);
 if(selectMember==null)throw new SecurityException("Member not found");
 if(!reservDAO.selectReservation(map).isEmpty())throw new IllegalStateException("Cancel upcoming appointments before withdrawal");

		if (hp.common.security.PasswordHash.verify((String)map.get("PWD"),String.valueOf(selectMember.get("PWD")))) {
			memberDAO.deleteMember(map);
			session.invalidate();

			return true;
		}

		return false;
	}
}
