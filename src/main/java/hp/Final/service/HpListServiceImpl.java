package hp.Final.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import hp.Final.dao.HpListDAO;
import hp.common.util.FileUtils;

@Service("hplistService")
public class HpListServiceImpl implements HpListService {
	int[] zoomDefault = { 20, 30, 50, 100, 250, 500, 1 * 1000, 2 * 1000, 4 * 1000, 8 * 1000, 16 * 1000, 32 * 1000,
			64 * 1000, 128 * 1000 };
	Logger log = Logger.getLogger(this.getClass());

	@Resource(name = "fileUtils")
	private FileUtils fileUtils;

	@Resource(name = "HpListDAO")
	private HpListDAO hplistDAO;

	@Override
	public List<Map<String, Object>> selectBoardList(Map<String, Object> map, HttpSession session) throws Exception {
		if (map.get("QUERY") == null || map.get("QUERY").equals("")) {
			map.put("QUERY", "selectAdminHpList");
		}
		map.put("ID", session.getAttribute("ID"));
		
		List<Map<String, Object>> tmpList = hplistDAO.selectBoardList(map);

		double lat, lon, maxLat, maxLon, minLat, minLon;
		lat = lon = maxLat = maxLon = minLat = minLon = 0;

		for (Map<String, Object> tmpMap : tmpList) {
			// 시간 포맷형식 변경
			String onhour = (String) tmpMap.get("ONHOUR");
			String offhour = (String) tmpMap.get("OFFHOUR");
			String hour = onhour.substring(0, 2) + ":" + onhour.substring(2) + " ~ " + offhour.substring(0, 2) + ":"
					+ offhour.substring(2);

			tmpMap.remove("OFFHOUR");
			tmpMap.remove("ONHOUR");
			tmpMap.put("HOUR", hour);

			// 좌표 포맷형식 변경
			String[] gps = ((String) tmpMap.get("ADDR_GPS")).split(",");

			tmpMap.remove("ADDR_GPS");
			tmpMap.put("LAT", gps[0]);// 위도
			tmpMap.put("LON", gps[1]);// 경도

			// 중심좌표 계산을 위해 필요
			double tmpLat, tmpLon;
			tmpLat = Double.parseDouble(gps[0]);
			tmpLon = Double.parseDouble(gps[1]);

			lat += tmpLat;
			lon += tmpLon;

			// zoom 계산을 위해 필요
			if (minLat == 0) {
				minLat = tmpLat;
				maxLat = tmpLat;
				minLon = tmpLon;
				maxLon = tmpLon;
			} else {
				if (minLat > tmpLat)
					minLat = tmpLat;
				if (maxLat < tmpLat)
					maxLat = tmpLat;
				if (minLon > tmpLon)
					minLon = tmpLon;
				if (maxLon < tmpLon)
					maxLon = tmpLon;
			}

			int distance = 0;

			if (map.get("CURRNET_LAT") != null && map.get("CURRNET_LON") != null) {
				String currentLat = (String) map.get("CURRNET_LAT");
				String currentLon = (String) map.get("CURRNET_LON");
				double cur_Lat = Double.valueOf(currentLat);
				double cur_Lon = Double.valueOf(currentLon);

				distance = GpstoMeter(tmpLat, cur_Lat, tmpLon, cur_Lon);

			} // end of if
			tmpMap.put("DISTANCE", distance);
		} // end of for

		Collections.sort(tmpList, new Comparator<Map<String, Object>>() {
			public int compare(Map<String, Object> m1, Map<String, Object> m2) {
				return ((Integer) m1.get("DISTANCE")).compareTo((Integer) m2.get("DISTANCE"));
			}
		});

		List<Map<String, Object>> resultList = new ArrayList<>();

		if (map.get("LIMIT_DISTANCE") == null || ((String) map.get("LIMIT_DISTANCE")).equals("")) {
			resultList = tmpList;
		} else {
			for (Map<String, Object> tmpMap : tmpList) {
				if (Integer.parseInt((String) map.get("LIMIT_DISTANCE")) < (Integer) tmpMap.get("DISTANCE"))
					break;

				resultList.add(tmpMap);
			}
			resultList.get(0).remove("TOTAL_COUNT");
			resultList.get(0).put("TOTAL_COUNT", resultList.size());
		}
		// 중심좌표 계산
		Map<String, Object> tmpMap = new HashMap<String, Object>();
		tmpMap.put("C_LAT", lat / tmpList.size());
		tmpMap.put("C_LON", lon / tmpList.size());

		// zoom 계산
		int zoom = GpstoMeter(minLat, maxLat, minLon, maxLon);

		for (int i = 0;; i++) {
			if (zoomDefault[i] > zoom) {
				tmpMap.put("zoom", (i - 1) < 0 ? 0 : i - 1);

				break;
			}
		}
		resultList.add(tmpMap);

		return resultList;
	}

	// 위도 경도를 거리로 환산하는 메소드
	public int GpstoMeter(double minLat, double maxLat, double minLon, double maxLon) {
		double _eQuatorialEarthRadius = 6378.1370D; // 지구의 반지름 km
		double _d2r = Math.PI / 180.0D;
		double dlong = (maxLon - minLon) * _d2r;
		double dlat = (maxLat - minLat) * _d2r;
		double a = Math.pow(Math.sin(dlat / 2D), 2D)
				+ Math.cos(minLat * _d2r) * Math.cos(maxLat * _d2r) * Math.pow(Math.sin(dlong / 2D), 2D);
		double c = 2D * Math.atan2(Math.sqrt(a), Math.sqrt(1D - a));
		double d = _eQuatorialEarthRadius * c;

		return (int) (d * 1000);
	}

	@Override
	public Map<String, Object> selectHpDetail(Map<String, Object> map) throws Exception {
		Map<String, Object> resultMap = hplistDAO.selectHpDetail(map);

		String onhour = (String) resultMap.get("ONHOUR");
		String offhour = (String) resultMap.get("OFFHOUR");

		resultMap.remove("OFFHOUR");
		resultMap.remove("ONHOUR");

		resultMap.put("HOUR", onhour.substring(0, 2) + ":" + onhour.substring(2) + " ~ " + offhour.substring(0, 2) + ":"
				+ offhour.substring(2));

		return resultMap;
	}
}
