import { Component, OnInit } from '@angular/core';
import {ApiService} from '../../services/api/api.service';

@Component({
  selector: 'app-transaction',
  templateUrl: './transaction.component.html',
  styleUrls: ['./transaction.component.css']
})
export class TransactionComponent implements OnInit {

  public sendToId: string;
  public amount: number;

  constructor(private walletService: ApiService) { }

  ngOnInit() {
  }

  private sendTransaction():void {
    this.walletService.sendTransaction(this.sendToId, this.amount);
  }

}
