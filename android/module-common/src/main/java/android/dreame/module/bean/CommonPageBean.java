package android.dreame.module.bean;

import java.util.List;

public class CommonPageBean<T> {

    /**
     * content : [{"content":"","deviceId":0,"extensions":{},"messageId":"","model":"","read":true,"readTime":"","sendTime":"","share":0,"type":0,"uid":""}]
     * empty : true
     * first : true
     * last : true
     * number : 0
     * numberOfElements : 0
     * pageable : {"offset":0,"pageNumber":0,"pageSize":0,"paged":true,"sort":{"empty":true,"sorted":true,"unsorted":true},"unpaged":true}
     * size : 0
     * sort : {"empty":true,"sorted":true,"unsorted":true}
     * totalElements : 0
     * totalPages : 0
     */

    private Boolean empty;
    private Boolean first;
    private Boolean last;
    private Integer number;
    private Integer numberOfElements;
    private PageableDTO pageable;
    private Integer size;
    private SortDTO sort;
    private Integer totalElements;
    private Integer totalPages;
    private List<T> content;

    public Boolean isEmpty() {
        return empty;
    }

    public void setEmpty(Boolean empty) {
        this.empty = empty;
    }

    public Boolean isFirst() {
        return first;
    }

    public void setFirst(Boolean first) {
        this.first = first;
    }

    public Boolean isLast() {
        return last;
    }

    public void setLast(Boolean last) {
        this.last = last;
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public Integer getNumberOfElements() {
        return numberOfElements;
    }

    public void setNumberOfElements(Integer numberOfElements) {
        this.numberOfElements = numberOfElements;
    }

    public PageableDTO getPageable() {
        return pageable;
    }

    public void setPageable(PageableDTO pageable) {
        this.pageable = pageable;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public SortDTO getSort() {
        return sort;
    }

    public void setSort(SortDTO sort) {
        this.sort = sort;
    }

    public Integer getTotalElements() {
        return totalElements;
    }

    public void setTotalElements(Integer totalElements) {
        this.totalElements = totalElements;
    }

    public Integer getTotalPages() {
        return totalPages;
    }

    public void setTotalPages(Integer totalPages) {
        this.totalPages = totalPages;
    }

    public List<T> getContent() {
        return content;
    }

    public void setContent(List<T> content) {
        this.content = content;
    }

    public static class PageableDTO {
        /**
         * offset : 0
         * pageNumber : 0
         * pageSize : 0
         * paged : true
         * sort : {"empty":true,"sorted":true,"unsorted":true}
         * unpaged : true
         */

        private Integer offset;
        private Integer pageNumber;
        private Integer pageSize;
        private Boolean paged;
        private SortDTO sort;
        private Boolean unpaged;

        public Integer getOffset() {
            return offset;
        }

        public void setOffset(Integer offset) {
            this.offset = offset;
        }

        public Integer getPageNumber() {
            return pageNumber;
        }

        public void setPageNumber(Integer pageNumber) {
            this.pageNumber = pageNumber;
        }

        public Integer getPageSize() {
            return pageSize;
        }

        public void setPageSize(Integer pageSize) {
            this.pageSize = pageSize;
        }

        public Boolean isPaged() {
            return paged;
        }

        public void setPaged(Boolean paged) {
            this.paged = paged;
        }

        public SortDTO getSort() {
            return sort;
        }

        public void setSort(SortDTO sort) {
            this.sort = sort;
        }

        public Boolean isUnpaged() {
            return unpaged;
        }

        public void setUnpaged(Boolean unpaged) {
            this.unpaged = unpaged;
        }
    }

    public static class SortDTO {
        /**
         * empty : true
         * sorted : true
         * unsorted : true
         */

        private Boolean empty;
        private Boolean sorted;
        private Boolean unsorted;

        public Boolean isEmpty() {
            return empty;
        }

        public void setEmpty(Boolean empty) {
            this.empty = empty;
        }

        public Boolean isSorted() {
            return sorted;
        }

        public void setSorted(Boolean sorted) {
            this.sorted = sorted;
        }

        public Boolean isUnsorted() {
            return unsorted;
        }

        public void setUnsorted(Boolean unsorted) {
            this.unsorted = unsorted;
        }
    }
}
