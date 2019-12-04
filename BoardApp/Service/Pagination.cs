using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BoardApp.Sservice
{
    public class Pagination
    {
        private int listSize = 10;     //초기값으로 목록개수를 10으로 셋팅

        private int rangeSize = 10;    //초기값으로 페이지범위를 10으로 셋팅  이전 <1 2 ...10> 다음

        private int page;              // 현재 페이지

        private int range;             // (현재) 각 페이지의 범위 시작 번호

        private int listCnt;           // 게시물 총 개수

        private int pageCnt;           // 전체 페이지 수 (전체게시물수/페이지당목록개수)

        private int startPage;         // 페이지의시작번호

        private int startList;         // 게시판 시작 번호

        private int endPage;           // 페이지의마지막번호, 이것을 기준으로 next버튼 비활성화

        private bool prev;

        private bool next;



        public int GetRangeSize()
        {

            return rangeSize;

        }



        public int GetPage()
        {

            return page;

        }



        public void SetPage(int page)
        {

            this.page = page;

        }



        public int SetRange()
        {

            return range;

        }



        public void SetRange(int range)
        {

            this.range = range;

        }



        public int GetStartPage()
        {

            return startPage;

        }



        public void SetStartPage(int startPage)
        {

            this.startPage = startPage;

        }



        public int GetEndPage()
        {

            return endPage;

        }



        public void SetEndPage(int endPage)
        {

            this.endPage = endPage;

        }



        public bool IsPrev()
        {

            return prev;

        }



        public void SetPrev(bool prev)
        {

            this.prev = prev;

        }



        public bool IsNext()
        {

            return next;

        }



        public void SetNext(bool next)
        {

            this.next = next;

        }



        public int GetListSize()
        {

            return listSize;

        }



        public void SetListSize(int listSize)
        {

            this.listSize = listSize;

        }



        public int GetListCnt()
        {

            return listCnt;

        }



        public void SetListCnt(int listCnt)
        {

            this.listCnt = listCnt;

        }



        public int GetStartList()
        {

            return startList;

        }



        public void PageInfo(int page, int range, int listCnt)
        {

            this.page = page;

            this.range = range;

            this.listCnt = listCnt;



            //전체 페이지수 

            decimal pageCountDecimal = listCnt / listSize;

            this.pageCnt = (int)Math.Ceiling(pageCountDecimal);



            //시작 페이지

            this.startPage = (range - 1) * rangeSize + 1;



            //끝 페이지

            this.endPage = range * rangeSize;



            //게시판 시작번호

            this.startList = (page - 1) * listSize;



            //이전 버튼 상태

            this.prev = range == 1 ? false : true;



            //다음 버튼 상태

            this.next = endPage > pageCnt ? false : true;

            if (this.endPage > this.pageCnt)
            {

                this.endPage = this.pageCnt;

                this.next = false;

            }

        }


    }
}