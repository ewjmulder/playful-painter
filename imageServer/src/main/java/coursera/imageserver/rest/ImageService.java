package coursera.imageserver.rest;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.util.Base64Utils;
import org.springframework.util.FileCopyUtils;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.util.UriUtils;
import java.io.File;
import java.io.IOException;
import java.util.Date;

@RestController()
@RequestMapping("image")
public class ImageService {

	@ResponseBody
	@RequestMapping(value = "upload", method = RequestMethod.POST)
	public String uploadImage(@RequestBody String imageBase64Post) throws IOException {
		// Cut off the meta part
		String imageBase64 = imageBase64Post.substring("imgBase64=data%3Aimage%2Fjpeg%3Bbase64%2C".length());
		String imageBase64Decoded = UriUtils.decode(imageBase64, "UTF-8");
		byte[] imageData = Base64Utils.decodeFromString(imageBase64Decoded);
		String filename = new Date().toString().replace(" ", "").replace(":", "-") + ".jpg";
		File file = new File("/root/images/" + filename);
		FileCopyUtils.copy(imageData, file);
		String imageUrl = "/image/download/" + filename;
		return imageUrl;
	}

	@RequestMapping(value = "download/{filename}.jpg", method = RequestMethod.GET, produces = MediaType.IMAGE_JPEG_VALUE)
	public byte[] downloadImage(@PathVariable("filename") String filename) throws IOException {
		File file = new File("/root/images/" + filename + ".jpg");
		return FileCopyUtils.copyToByteArray(file);
	}

	@RequestMapping(value = "showAll", method = RequestMethod.GET)
	public String showAllImages() throws IOException {
		String html = "<html><head></head><body><ul>";
		File dir = new File("/root/images");
		File[] directoryListing = dir.listFiles();
		for (File imageFile : directoryListing) {
			html += "<li><a href='/image/download/" + imageFile.getName() + "'>" + imageFile.getName() + "</a></li>";
		}
		html += "</ul></body></html>";
		return html;
	}

}
