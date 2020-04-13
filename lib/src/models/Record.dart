
class Record{
  String codigo;
  String descripcionDelProducto;
  String lote;
  String fechaDeVencimiento;
  String motivoDeDevolucion;
  String cantidad;


  Record({this.codigo, this.descripcionDelProducto, this.lote,
      this.fechaDeVencimiento, this.motivoDeDevolucion, this.cantidad});

  factory Record.fromJson(Map<String, dynamic> json){
    return Record(
      codigo: json['codigo'],
      descripcionDelProducto: json['descripcionDelProducto'],
      lote : json['lote'],
      fechaDeVencimiento : json['fechaDeVencimiento'],
      motivoDeDevolucion : json['motivoDeDevolucion'],
      cantidad : json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() => {
    'codigo' : codigo,
    'descripcionDelProducto' : descripcionDelProducto,
    'lote' : lote,
    'fechaDeVencimiento' : fechaDeVencimiento,
    'motivoDeDevolucion' : motivoDeDevolucion,
    'cantidad' : cantidad,
  };
}