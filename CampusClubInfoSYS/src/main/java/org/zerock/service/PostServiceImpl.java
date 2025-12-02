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

    // 1. FileMapper 주입
    @Setter(onMethod_ = @Autowired)
    private FileMapper fileMapper;

    // 2. 파일 업로드 기본 경로
    private String uploadFolder = "C:\\upload";

    // 3. 날짜별 폴더 경로 생성
    private String getFolder() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String str = sdf.format(date);
        // File.separator: OS에 맞는 경로 구분자 (e.g., 윈도우: \, 리눅스: /)
        return str.replace("-", File.separator);
    }

    // 4. 트랜잭션 적용
    @Transactional
    @Override
    public void register(PostVO post) {
        log.info("register......" + post);
        
        // 1. Post 테이블에 게시글 등록 (insertSelectKey 사용으로 post_id가 VO에 세팅됨)
        mapper.insertSelectKey(post);
        log.info("방금 등록된 post_id: " + post.getPost_id());
        
        Long post_id = post.getPost_id();

        // 2. 파일 업로드 처리
        if (post.getUploadFiles() == null || post.getUploadFiles().isEmpty()) {
            log.info("첨부파일 없음. 등록 종료.");
            return;
        }

        // 3. 날짜별 업로드 폴더 생성
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
                // 4. File 테이블에 파일 정보 등록
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
        
        // 1. 게시글 정보 가져오기
		PostVO post = mapper.read(post_id);
        
        // 2. 첨부파일 목록 가져오기 (추가된 부분)
        if (post != null) {
            // fileMapper를 이용해 post_id에 해당하는 파일 리스트를 가져와서
            // post 객체의 attachList 필드에 세팅합니다.
            post.setAttachList(fileMapper.findByPostId(post_id));
        }
        
        // 3. 게시글 정보 + 첨부파일 목록이 담긴 post 객체 반환
		return post;
	}
    
//    @Transactional
//	@Override
//	public boolean modify(PostVO post) {
//		log.info("modify......" + post);
//		return mapper.update(post) == 1;
//	}
    @Transactional // 👈 1. 트랜잭션 어노테이션 추가
	@Override
	public boolean modify(PostVO post) {
		log.info("modify......" + post);
		
		// 2. 게시글 텍스트 내용 업데이트
		boolean modifyResult = mapper.update(post) == 1;
		
		// 3. 새로운 파일 업로드 처리 (register 메소드와 동일한 로직) 👇
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
					
					// 4. File 테이블에 파일 정보 등록
					fileMapper.insert(fileVO);

				} catch (IllegalStateException | IOException e) {
					log.error("파일 저장 실패: " + e.getMessage());
					// @Transactional에 의해 게시글 수정도 롤백됨
					throw new RuntimeException("파일 저장에 실패했습니다.", e);
				}
			} // end for
		} // end if
		
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
        
        // ⭐️ 리스트에 썸네일용 대표 파일 정보 채우기
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