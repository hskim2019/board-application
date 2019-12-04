using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BoardApp.Service
{
    public class BoardPager
    {

        // 페이지 당 게시물 수
        public static readonly int PAGE_SCALE = 10;
        // 화면에 보일 페이지 수
        public static readonly int BLOCK_SCALE = 10;

        // 현재 페이지
        private int curPage;
        // 이전 페이지
        private int prevPage;
        // 다음 페이지
        private int nextPage;
        // 전체 페이지 개수
        private int totalPage;
        // 전체 페이지 블록 갯수 (전체페이지수 10, 화면에보이는페이지수5, 블록은2개)
        private int totalBlock;
        // 현재페이지블록
        private int curBlock;
        // 이전 페이지 블록
        private int prevBlock;
        // 다음 페이지 블록
        private int nextBlock;

        // WHERE rowNo BETWEEN #{start} AND #{end}
        private int pageBegin;
        private int pageEnd;

        // 현재 페이지 블록의 시작 번호
        // [이전] 41 42 43 44 [다음]   "41"
        private int blockBegin;
        // 현재 페이지 블록의 끝번호
        private int blockEnd;

        // 생성자
        // BoardPager(전체레코드개수, 현재페이지번호)
        // BoardPager(int rowCount, int curPage)
        public BoardPager(int rowCount, int curPage)
        {
            curBlock = 1;
            this.curPage = curPage;

            // 전체 페이지 개수 계산하기
            setTotalPage(rowCount);

            // 리스트를 가져 올 페이지의 시작번호, 끝번호 계산
            setPageRange();

            // 전체 페이지 블록 개수 계산
            setTotalBlock();

            // 페이지 블록의 시작과 끝 번호 계산
            setBlockRange();
        }

           
        // 페이지 블록의 시작과 끝 계산하기
        public void setBlockRange()
        {
            // 현재 페이지가 몇 번째 페이지 블록에 속하는지 계산
            curBlock = (int)((curPage - 1) / BLOCK_SCALE) + 1;

            // 현재 페이지 블록의 시작, 끝 번호 계산
            blockBegin = (curBlock - 1) * BLOCK_SCALE + 1;

            // 페이지 블록의 끝번호
            blockEnd = blockBegin + BLOCK_SCALE - 1;

            // 마지막 블록이 범위를 초과하지 않도록 계산
            if(blockEnd > totalPage)
            {
                blockEnd = totalPage;
            }

            // 이전을 눌렀을 때 이동 할 페이지 번호
            prevPage = (curPage == 1) ? 1 : (curBlock - 1) * BLOCK_SCALE;

            // 다음을 눌렀을 때 이동할 페이지 번호
            nextPage = curBlock > totalBlock ? (curBlock * BLOCK_SCALE) : (curBlock * BLOCK_SCALE) + 1;

            // 마지막 페이지가 범위를 초과하지 않도록 처리
            if (nextPage >= totalPage) nextPage = totalPage;
        }


        // 가져 올 페이지의 시작, 끝번호 계산
        public void setPageRange()
        {
            pageBegin = (curPage - 1) * PAGE_SCALE + 1;
            pageEnd = pageBegin + PAGE_SCALE - 1;
        }

        // Getter /Setter
        

    }
}