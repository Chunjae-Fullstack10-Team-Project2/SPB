package net.spb.spb.service;

import com.sun.jna.platform.win32.Netapi32Util;
import net.spb.spb.dto.MemberDTO;
import net.spb.spb.util.HttpUtil;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.net.URLEncoder;

@Service
public class NaverLoginService {

    private static final String CLIENT_ID = "YOUR_CLIENT_ID";
    private static final String CLIENT_SECRET = "YOUR_CLIENT_SECRET";
    private static final String REDIRECT_URI = "http://localhost:8080/naverLogin";

    public String getAccessToken(String code, String state) throws Exception {
        String tokenUrl = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code"
                + "&client_id=" + CLIENT_ID
                + "&client_secret=" + CLIENT_SECRET
                + "&redirect_uri=" + URLEncoder.encode(REDIRECT_URI, "UTF-8")
                + "&code=" + code
                + "&state=" + state;

        // Call Naver API to get access token
        String response = HttpUtil.get(tokenUrl);
        JSONObject jsonResponse = new JSONObject(response);
        return jsonResponse.getString("access_token");
    }

    public MemberDTO getUserInfo(String accessToken) throws Exception {
        String profileUrl = "https://openapi.naver.com/v1/nid/me";
        String response = HttpUtil.get(profileUrl, accessToken);

        // Parse the user info
        JSONObject jsonResponse = new JSONObject(response);
        JSONObject responseObj = jsonResponse.getJSONObject("response");
        String email = responseObj.getString("email");
        String name = responseObj.getString("name");

        MemberDTO memberDTO = new MemberDTO();
        memberDTO.setMemberEmail(email);
        memberDTO.setMemberName(name);

        return memberDTO;
    }
}
