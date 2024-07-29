//
// Copyright (c) 2024, Novant LLC
// Licensed under the MIT License
//
// History:
//   21 Jul 2024  Andy Frank  Creation
//

*************************************************************************
** DxDiff
*************************************************************************

** DxDiff models a modification to a 'DxRec'.
@Js const class DxDiff
{
  ** Return diff to add a rec to bucket.
  new makeAdd(Str bucket, Str:Obj? map)
  {
    this.bucket = bucket
    this.op  = 0
    this.changes = map
  }

  ** Return diff to update an existing rec.
  new makeUpdate(Str bucket, Int id, Str:Obj? changes)
  {
    this.bucket = bucket
    this.op  = 1
    this.id  = id
    this.changes = changes
  }

  ** Return diff to delete an existing rec.
  new makeDelete(Str bucket, Int id)
  {
    this.bucket = bucket
    this.op  = 2
    this.id  = id
  }

  ** TODO: use Int ref instead of Str [pointer]?
  const Str bucket

  ** Diff op: 0=add, 1=update, 2=delete
  const Int op

  ** The corresponding record id for this diff or 'null' for add.
  const Int? id

  ** Modifications to apply to record.
  const [Str:Obj?]? changes
}
