class FileModel {
  final String name, url;
  FileModel({required this.name, required this.url});
}

List<FileModel> dummyFileList = [
  FileModel(
      name: 'file1', url: 'https://research.nhm.org/pdfs/10840/10840-002.pdf'),
  FileModel(
      name: 'file2',
      url:
          'https://file-examples.com/storage/fe63486cdb63c429195a385/2017/04/file_example_MP4_480_1_5MG.mp4'),
  FileModel(
      name: 'file3',
      url:
          'https://file-examples.com/storage/fe63486cdb63c429195a385/2017/10/file_example_JPG_500kB.jpg'),
  FileModel(
      name: 'file4',
      url:
          'https://file-examples.com/storage/fe63486cdb63c429195a385/2017/10/file-example_PDF_1MB.pdf'),
];
