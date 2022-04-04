import '/res/assets_files.dart';

class MTitle {
  String title;
  bool select;
  String ic;
  String icA;
  MTitle(
      {required this.title,
      required this.select,
      required this.ic,
      required this.icA});
}

List<MTitle> adminTitles = [
  MTitle(
      title: "Tableau de bord",
      select: true,
      ic: MmgAssets.dashRegular,
      icA: MmgAssets.dash),
  MTitle(
      title: "Magasins",
      select: false,
      ic: MmgAssets.magasinRegular,
      icA: MmgAssets.magasin),
  MTitle(
      title: "Ventes",
      select: false,
      ic: MmgAssets.ventesRegular,
      icA: MmgAssets.ventes),
  MTitle(
      title: "Dettes",
      select: false,
      ic: MmgAssets.dettesRegular,
      icA: MmgAssets.dettes),
  MTitle(
      title: "Produits",
      select: false,
      ic: MmgAssets.productsRegular,
      icA: MmgAssets.products),
  MTitle(
      title: "Approvisionnements",
      select: false,
      ic: MmgAssets.procurementRegular,
      icA: MmgAssets.procurement),
  MTitle(
      title: "Stock",
      select: false,
      ic: MmgAssets.stockRegular,
      icA: MmgAssets.stock),
  MTitle(
      title: "Employés",
      select: false,
      ic: MmgAssets.employeeRegular,
      icA: MmgAssets.employee),
  MTitle(
      title: "Clients",
      select: false,
      ic: MmgAssets.clientRegular,
      icA: MmgAssets.client),
  MTitle(
      title: "Infos",
      select: false,
      ic: MmgAssets.infoRegular,
      icA: MmgAssets.info),
];

List<MTitle> employeeTitles = [
  MTitle(
      title: "Tableau de bord",
      select: true,
      ic: MmgAssets.dashRegular,
      icA: MmgAssets.dash),
  MTitle(
      title: "Ventes",
      select: false,
      ic: MmgAssets.ventesRegular,
      icA: MmgAssets.ventes),
  MTitle(
      title: "Dettes",
      select: false,
      ic: MmgAssets.dettesRegular,
      icA: MmgAssets.dettes),
  MTitle(
      title: "Inventaires",
      select: false,
      ic: MmgAssets.inventoryRegular,
      icA: MmgAssets.inventory),
  MTitle(
      title: "Approvisionnements",
      select: false,
      ic: MmgAssets.procurementRegular,
      icA: MmgAssets.procurement),
  MTitle(
      title: "Stock",
      select: false,
      ic: MmgAssets.stockRegular,
      icA: MmgAssets.stock),
  MTitle(
      title: "Info",
      select: false,
      ic: MmgAssets.infoRegular,
      icA: MmgAssets.info),
];
