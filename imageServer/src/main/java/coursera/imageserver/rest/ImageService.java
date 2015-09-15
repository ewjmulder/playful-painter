package coursera.imageserver.rest;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController()
@RequestMapping("image")
public class ImageService {

	@RequestMapping(value = "upload", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public String getOrder(@RequestBody String imageBase64) {
		String imageUrl = imageBase64;
		System.out.println("imageBase64: " + imageBase64);
		return imageUrl.substring(0, 10);
	}

}
