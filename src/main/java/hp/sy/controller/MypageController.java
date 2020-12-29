package hp.sy.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import hp.Final.service.MypageService;
import hp.Final.service.ReservService;
import hp.common.common.CommandMap;

@Controller
@RequestMapping("/mypage")
public class MypageController {
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "mypageService")
	private MypageService mypageService;

	@Resource(name = "reservService")
	private ReservService reservService;

	// 마이페이지 메인페이지
	@RequestMapping("/OpenMypageMain")
	public String OpenMypageMain(Model model) throws Exception {
		model.addAttribute("body", "mypageMain");

		return "mainForm";
	}

	// 마이페이지 내 정보 수정
	@RequestMapping("/updateUserInfo")
	public String updateUserInfo(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		commandMap.getMap().put("ID", session.getAttribute("ID"));
		
		mypageService.updateUserInfo(commandMap.getMap());
		
		return "jsonView";
	}

	// 유저 정보 불러오기
	@RequestMapping("/selectUserInfo")
	public String selectUserInfo(Model model, HttpSession session) throws Exception {
		Map<String, Object> map = mypageService.selectUserInfo(session);
		model.addAttribute("map", map.get("detail"));

		return "jsonView";
	}
	
	// 마이페이지 이미지 파일
	@RequestMapping("/InsertImgform")
	public String insertImgform(Model model, HttpSession session) throws Exception {
		Map<String, Object> map = mypageService.selectUserInfo(session);

		model.addAttribute("map", map.get("detail"));
		
		return "sy/mypage/ImgInsert";
	}
	
	// 이미지 등록
	@RequestMapping("/InsertImg")
	public String insertImg(CommandMap commandMap, Model model, HttpSession session, MultipartHttpServletRequest multipartHttpServletRequest) throws Exception {
		mypageService.insertIMG(commandMap.getMap(), session, multipartHttpServletRequest);
		
		model.addAttribute("step", "closeWindow");

		return "sy/mypage/ImgInsert";
	}
	
	@RequestMapping("/DeleteImg")
	public String deleteImg(CommandMap commandMap, Model model, HttpSession session, HttpServletRequest request) throws Exception {
		mypageService.deleteIMG(commandMap.getMap(), session, request);
		
		model.addAttribute("step", "closeWindow");

		return "sy/mypage/ImgInsert";
	}
	
	// 마이페이지 회원탈퇴
	@RequestMapping("/deleteForm") 
	public String deleteMemberForm(CommandMap commandMap, Model model, HttpSession session) throws Exception {		
		model.addAttribute("IDX", session.getAttribute("IDX"));
		
		return "sy/mypage/delete"; 
	}
	
	@RequestMapping("/delete")
	public String deleteMember(CommandMap commandMap, Model model, HttpSession session) throws Exception {		
		mypageService.deleteMember(commandMap.getMap()); 
		
		session.invalidate(); 
		
		return "jsonView";
	}
	
	// 포인트 적립하기
	@RequestMapping("/paymentPoint")
	public String updatePoint(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		model.addAttribute("ID", commandMap.getMap().get("ID"));

		mypageService.updatePoint(commandMap.getMap(), session);

		return "jsonView";
	}

	// 마이페이지 예약내역페이지
	@RequestMapping("/OpenMypageReserv")
	public String openMyReserv(CommandMap commandMap, Model model) throws Exception {

		return "sy/mypage/myreserv";
	}

	// 마이페이지 관심병원리스트페이지
	@RequestMapping("/OpenMypageFavhp")
	public String openMypageFavhp(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		List<Map<String, Object>> list = mypageService.selectFavList(commandMap.getMap(), session);

		model.addAttribute("list", list);
		model.addAttribute("body", "myFavList");

		return "mainForm";
	}

	// 마이페이지 관심병원등록하기버튼
	@RequestMapping("/InsertFav")
	public String insertFav(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		mypageService.insertFav(commandMap.getMap(), session);
		
		return "jsonView";
	}

	// 마이페이지 관심병원 삭제하기
	@RequestMapping("/DelFavHp")
	public String delFavHp(CommandMap commandMap, Model model, HttpSession session) throws Exception {
		mypageService.delFavHp(commandMap.getMap(), session);

		return "redirect:OpenMypageFavhp";
	}
}
