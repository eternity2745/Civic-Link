class DescriptionTrimmer{
  static String trimDescription(String description, int length){
    if(description.length > length){
      return "${description.substring(0, length)}...";
    }
    return description;
  }
}