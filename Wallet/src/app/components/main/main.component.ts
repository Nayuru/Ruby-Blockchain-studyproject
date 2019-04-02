import { Component, OnInit } from '@angular/core';
import {ApiService} from '../../services/api/api.service';

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.css']
})
export class MainComponent implements OnInit {

  protected  mockData = [
    {
      id: 'Tjf35jhg',
      amount: '+250',
      to: 'Jlfh55e2',
      date: '23/25/2018'
    },
    {
      id: 'Tjf35jhg',
      amount: '+250',
      to: 'Jlfh55e2',
      date: '23/25/2018'
    },
    {
      id: 'Tjf35jhg',
      amount: '+250',
      to: 'Jlfh55e2',
      date: '23/25/2018'
    }
    ,
    {
      id: 'Tjf35jhg',
      amount: '+250',
      to: 'Jlfh55e2',
      date: '23/25/2018'
    }
    ,
    {
      id: 'Tjf35jhg',
      amount: '+250',
      to: 'Jlfh55e2',
      date: '23/25/2018'
    },
    {
      id: 'Tjf35jhg',
      amount: '+250',
      to: 'Jlfh55e2',
      date: '23/25/2018'
    }
    ,
    {
      id: 'Tjf35jhg',
      amount: '+250',
      to: 'Jlfh55e2',
      date: '23/25/2018'
    }
    ,
    {
      id: 'Tjf35jhg',
      amount: '+250',
      to: 'Jlfh55e2',
      date: '23/25/2018'
    }
  ];
  protected mockUserData = {
    id: 'azerty',
    nick: 'taMere',
    balance: -256,
    monthlyIn: +425,
    monthlyOut: -452
  };

  constructor(private walletService: ApiService) { }

  ngOnInit() {
    this.walletService.userId = this.mockUserData.id;
  }

}
