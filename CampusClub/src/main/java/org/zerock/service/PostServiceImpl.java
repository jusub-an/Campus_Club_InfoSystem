package org.zerock.service;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // 추가
import org.springframework.web.multipart.MultipartFile; // 추가
import org.zerock.domain.Criteria;
import org.zerock.domain.FileVO; // 추가
import org.zerock.domain.PostVO;
import org.zerock.mapper.FileMapper; // 추가
import org.zerock.mapper.PostMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
// @AllArgsConstructor 대신 Setter 주입으로 변경 (FileMapper도 주입해야 하므로)
public class PostServiceImpl implements PostService {

    @Setter(onMethod_ = @Autowired)
    private PostMapper mapper;
    
    @Setter(onMethod_ = @Autowired)
    private ReplyMapper replyMapper;

    @Setter(onMethod_ = @Autowired)
    private FileMapper fileMapper;

    private String uploadFolder = "C:\\upload";

    private String getFolder() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String str = sdf.format(date);
        
        return str.replace("-", File.separator);
    }

    @Transactional
    @Override
    public void register(PostVO post) {
        log.info("register......" + post);
        
        mapper.insertSelectKey(post);
        log.info("방금 등록된 post_id: " + post.getPost_id());
        
        Long post_id = post.getPost_id();

        if (post.getUploadFiles() == null || post.getUploadFiles().isEmpty()) {
            log.info("첨부파일 없음. 등록 종료.");
            return;
        }

        File uploadPath = new File(uploadFolder, getFolder());
        if (!uploadPath.exists()) {
            uploadPath.mkdirs(); 
        }

        for (MultipartFile multipartFile : post.getUploadFiles()) {
            if (multipartFile.isEmpty()) {
                continue;
            }

            log.info("-------------------------------------");
            log.info("Upload File Name: " + multipartFile.getOriginalFilename());
            log.info("Upload File Size: " + multipartFile.getSize());

            String originalFileName = multipartFile.getOriginalFilename();
            // UUID로 고유한 파일명 생성
            String uuid = UUID.randomUUID().toString();
            String saveFileName = uuid + "_" + originalFileName;

            // FileVO 생성
            FileVO fileVO = new FileVO();
            fileVO.setPost_id(post_id);
            fileVO.setFile_name(originalFileName);
            // storage_path 에는 날짜 경로 + UUID 파일명을 저장
            fileVO.setStorage_path(getFolder() + File.separator + saveFileName);

            try {
                // 실제 파일 저장
                File saveFile = new File(uploadPath, saveFileName);
                multipartFile.transferTo(saveFile); 
                
                fileMapper.insert(fileVO);

            } catch (IllegalStateException | IOException e) {
                log.error("파일 저장 실패: " + e.getMessage());
                // @Transactional에 의해 게시글 등록도 롤백됨
                throw new RuntimeException("파일 저장에 실패했습니다.", e);
            }
        }
    }

    @Override
	public PostVO get(Long post_id) {
		log.info("get......" + post_id);
        
		PostVO post = mapper.read(post_id);
        
        if (post != null) {
            // fileMapper를 이용해 post_id에 해당하는 파일 리스트를 가져와서
            // post 객체의 attachList 필드에 세팅합니다.
            post.setAttachList(fileMapper.findByPostId(post_id));
        }
        
		return post;
	}
    
    @Transactional
	@Override
	public boolean modify(PostVO post) {
		log.info("modify......" + post);
		
		boolean modifyResult = mapper.update(post) == 1;
		
		if (post.getUploadFiles() != null && !post.getUploadFiles().isEmpty()) {
			
			Long post_id = post.getPost_id();
			
			// 날짜별 업로드 폴더 생성
			File uploadPath = new File(uploadFolder, getFolder());
			if (!uploadPath.exists()) {
				uploadPath.mkdirs(); 
			}

			for (MultipartFile multipartFile : post.getUploadFiles()) {
				if (multipartFile.isEmpty()) {
					continue;
				}

				String originalFileName = multipartFile.getOriginalFilename();
				// IE 경로명 제거
				if (originalFileName != null) {
					originalFileName = originalFileName.substring(originalFileName.lastIndexOf("\\") + 1);
				}
				
				String uuid = UUID.randomUUID().toString();
				String saveFileName = uuid + "_" + originalFileName;

				FileVO fileVO = new FileVO();
				fileVO.setPost_id(post_id);
				fileVO.setFile_name(originalFileName);
				fileVO.setStorage_path(getFolder() + File.separator + saveFileName);

				try {
					File saveFile = new File(uploadPath, saveFileName);
					multipartFile.transferTo(saveFile);
					
					fileMapper.insert(fileVO);

				} catch (IllegalStateException | IOException e) {
					log.error("파일 저장 실패: " + e.getMessage());
					throw new RuntimeException("파일 저장에 실패했습니다.", e);
				}
			} 
		} 
		
		return modifyResult;
	}
    
    @Transactional
	@Override
	public boolean remove(Long post_id) {
		log.info("remove...." + post_id);
//		replyMapper.deleteByPostId(post_id);
		return mapper.delete(post_id) == 1;
	}

	@Override
	public List<PostVO> getList() {
		log.info("getList..........");
		return mapper.getList();
	}
	
	@Override
    public List<PostVO> getList(Criteria cri) {
        log.info("getList..........");
        List<PostVO> list = mapper.getListWithPaging(cri);
        
        // 리스트에 썸네일용 대표 파일 정보 채우기
        for (PostVO post : list) {
            // 해당 게시글의 파일 목록 가져오기 (이미 Mapper에서 정렬되어 있음: 대표가 0번)
            List<FileVO> files = fileMapper.findByPostId(post.getPost_id());
            if (files != null && !files.isEmpty()) {
                post.setAttachList(files); // 전체를 넣거나, 대표 1개만 넣어도 됨
            }
        }
        return list;
    }
	
	@Override
    public int getTotal(Criteria cri) {
        log.info("get total count");
        return mapper.getTotalCount(cri);
    }
	
	@Override
	public String getClubName(Long club_id) {
		return mapper.getClubName(club_id);
	}
}