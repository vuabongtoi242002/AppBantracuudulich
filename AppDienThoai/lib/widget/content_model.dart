class UnBoardingContent {
  String image;
  String title;
  String description;
  UnBoardingContent(
      {required this.description,
        required this.image,
        required this.title});
}

List<UnBoardingContent> contents = [
  UnBoardingContent(
    description: 'Người lãnh tụ vĩ đại của chúng ta',
    image: "image/BacHo.jpg",
    title: 'Việt Nam\n  Muôn Năm  '),
  UnBoardingContent(
      description: 'Người đốt lò Việt Nam',
      image: "image/BacTrong.jpg",
      title: 'Lò mãi cháy trong tim người Việt Nam'),
  UnBoardingContent(
      description: '',
      image: "image/5.png",
      title: 'Kỷ niệm 2/9'),
];