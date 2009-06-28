<script language="javascript" type="text/javascript" runat="server">
    function toCount(recordCount, rowsPerpage)
    {
        pageCount = (recordCount / rowsPerpage);

        rounded = Math.round(pageCount);

        pageCount = (rounded >= pageCount) ? Math.round(pageCount) : (Math.round(pageCount) + 1);

        return pageCount;
    }
</script>