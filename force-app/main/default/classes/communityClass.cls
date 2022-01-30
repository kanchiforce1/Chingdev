public class communityClass{
public PageReference gotoPage2(){
    String URL = '/apex/PPW_Transmittal?ps=a021H00000Je4xDQAR&v=a071H00000dSi5IQAS';
    PageReference pageRef = new PageReference(URL);
    pageRef.setRedirect(false);
    return pageRef;
}

}