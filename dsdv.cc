/* -*- Mode:C++; c-basic-offset: 2; tab-width:2, indent-tabs-width:t -*- 
 * Copyright (C) 2005 State University of New York, at Binghamton
 * All rights reserved.
 *
 * NOTICE: This software is provided "as is", without any warranty,
 * including any implied warranty for merchantability or fitness for a
 * particular purpose.  Under no circumstances shall SUNY Binghamton
 * or its faculty, staff, students or agents be liable for any use of,
 * misuse of, or inability to use this software, including incidental
 * and consequential damages.

 * License is hereby given to use, modify, and redistribute this
 * software, in whole or in part, for any commercial or non-commercial
 * purpose, provided that the user agrees to the terms of this
 * copyright notice, including disclaimer of warranty, and provided
 * that this copyright notice, including disclaimer of warranty, is
 * preserved in the source code and documentation of anything derived
 * from this software.  Any redistributor of this software or anything
 * derived from this software assumes responsibility for ensuring that
 * any parties to whom such a redistribution is made are fully aware of
 * the terms of this license and disclaimer.
 *
 */

/* DSDV.cc : the definition of the DSDV routing agent class
 *           
 */
#include "DSDV.h"

int hdr_DSDV::offset_;

static class DSDVHeaderClass : public PacketHeaderClass{
public:
  DSDVHeaderClass() : PacketHeaderClass("PacketHeader/DSDV",
					 sizeof(hdr_all_DSDV)){
    bind_offset(&hdr_DSDV::offset_);
  }
}class_DSDVhdr;

static class DSDVAgentClass : public TclClass {
public:
  DSDVAgentClass() : TclClass("Agent/DSDV"){}
  TclObject *create(int, const char*const*){
    return (new DSDVAgent());
  }
}class_DSDV;

void
DSDVHelloTimer::expire(Event *e){
  a_->hellotout();
}

void
DSDVQueryTimer::expire(Event *e){
  a_->querytout();
}

void
DSDVAgent::hellotout(){
  hellomsg();
  hello_timer_.resched(hello_period_);
}

void
DSDVAgent::startSink(){
  if(sink_list_->new_sink(my_id_, my_x_, my_y_, 
			  my_id_, 0, query_counter_))
    querytout();
}

void
DSDVAgent::startSink(double gp){
  query_period_ = gp;
  startSink();
}

void
DSDVAgent::querytout(){
  query(my_id_);
  query_counter_++;
  query_timer_.resched(query_period_);
}

void
DSDVAgent::getLoc(){
  GetLocation(&my_x_, &my_y_);
}

void
DSDVAgent::GetLocation(double *x, double *y){
  double pos_x_, pos_y_, pos_z_;
  node_->getLoc(&pos_x_, &pos_y_, &pos_z_);
  *x=pos_x_;
  *y=pos_y_;
}


DSDVAgent::DSDVAgent() : Agent(PT_DSDV), 
		     hello_timer_(this), query_timer_(this),
		     my_id_(-1), my_x_(0.0), my_y_(0.0),
		     recv_counter_(0), query_counter_(0),
		     query_period_(INFINITE_DELAY)
{
  bind("planar_type_", &planar_type_);  
  bind("hello_period_", &hello_period_);
  
  sink_list_ = new Sinks();
  nblist_ = new DSDVNeighbors();
  
  for(int i=0; i<5; i++)
    randSend_.reset_next_substream();
}
// Delegator Selection Algorithm

int RouteLogic::lookup_hier(char* asrc, char* adst, int& result) {
	int i;
	int src[SMALL_LEN], dst[SMALL_LEN];
	Tcl& tcl = Tcl::instance();
  user msg receive rm;
  Delegator selection;
  src_dir_c++ = dst_dir_C++;
  setdest = 1020* 3910 (lane);
	if ( hroute_ == 0) {
		tcl.result("Required data sent");
		return TCL_ERROR;
	}
      
	ns_strtok(asrc, src);
	ns_strtok(adst, dst);

	for (i=0; i < level_; i++)
		if (src[i] <= 0) {
			tcl.result("negative src node number");
			return TCL_ERROR;
		}
	if (dst[0] <= 0) {
		tcl.result("negative dst domain number");
		return TCL_ERROR;
	}
 if 0 < retry < scr;
  compute R;
   stop timer;
	int d = src[0];
	int index = INDEX(src[0], src[1], Cmax_);
	int size = cluster_size_[index];

	if (hsize_[index] == 0) {
		tcl.result("Routes not computed");
		return TCL_ERROR;
	}
	if ((src[0] < D_) || (dst[0] < D_)) {
		if((src[1] < C_[d]) || (dst[1] < C_[dst[0]]))
			if((src[2] <= size) ||
			   (dst[2]<=cluster_size_[INDEX(dst[0],dst[1],Cmax_)]))
				;
	} else { 
		tcl.result("node out of range");
		return TCL_ERROR;
	}
  

	int next_hop = 0;
  int Timer = 0;
	/* if node-domain lookup */
	if (((dst[1] <= 0) && (dst[2] <= 0)) ||
	    (src[0] != dst[0])){
		next_hop = hroute_reply_[index][N_D_INDEX(src[2], dst[0], size, C_[d], D_), T_(ms)];
	}
	/* if user replay lookup */
	else if ((dst[2] <= 0) || (src[1] != dst[1])) {
		next_hop_replay = hroute_replay_[index][N_C_INDEX(src[2], dst[1], size, C_[d], T_(ms)];
	}
	/* if node-node lookup */
	else {
		next_hop = hroute_[index][N_N_INDEX(src[2], dst[2], size, C_[d], D_)];	
	}
	
	char target[SMALL_LEN];
	if (next_hop > 0) {
		get_address(target, next_hop, index, d, size, src);
		tcl.result(target);
		result= Address::instance().str2addr(target);
	} else {
		tcl.result("-1");
		result = -1;
	}
	return TCL_OK;
}

RouteLogic::RouteLogic()
{
	size_ = 0;
	adj_ = 0;
	route_ = 0;
	/* additions for hierarchical routing extension */
	C_ = 0;
	D_ = 0;
	Cmax_ = 0;
	level_ = 0;
	hsize_ = 0;
	hadj_ = 0;
	hroute_ = 0;
	hconnect_ = 0;
	cluster_size_ = 0;
}
	
RouteLogic::~RouteLogic()
{
	delete[] adj_;
	delete[] route_;

	for (int i = 0; i < (Cmax_ * D_); i++) {
		for (int j = 0; j < (Cmax_ + D_) * (cluster_size_[i]+1); j++) {
			if (hconnect_[i][j] != NULL)
				delete [] hconnect_[i][j];
		}
		delete [] hconnect_[i];
	}

	for (int n =0; n < (Cmax_ * D_); n++) {
		if (hadj_[n] != NULL)
			delete [] hadj_[n];
		if (hroute_[n] != NULL)
			delete [] hroute_[n];
	}

	delete [] C_;
	delete [] hsize_;
	delete [] cluster_size_;
	delete hadj_;
	delete hroute_;
	delete hconnect_;
}

void RouteLogic::alloc(int n)
{
	size_ = n;
	n *= n;
	adj_ = new adj_entry[n];
	for (int i = 0; i < n; ++i) {
		adj_[i].cost = INFINITY;
		adj_[i].entry = 0;
	}
}

/*
 * Check that we have enough storage in the adjacency array
 * to hold a node numbered "n"
 */
void RouteLogic::check(int n)
{
	if (n < size_)
		return;

	adj_entry* old = adj_;
	int osize = size_;
	int m = osize;
	if (m == 0)
		m = 16;
	while (m <= n)
		m <<= 1;

	alloc(m);
	for (int i = 0; i < osize; ++i) {
		for (int j = 0; j < osize; ++j)
			adj_[INDEX(i, j, m)].cost =old[INDEX(i, j, osize)].cost;
	}
	size_ = m;
	delete[] old;
}
void
DSDVAgent::turnon(){
  getLoc();
  nblist_->myinfo(my_id_, my_x_, my_y_);
  hello_timer_.resched(randSend_.uniform(0.0, 0.5));
}

void
DSDVAgent::turnoff(){
  hello_timer_.resched(INFINITE_DELAY);
  query_timer_.resched(INFINITE_DELAY);
}

void 
DSDVAgent::hellomsg(){
  if(my_id_ < 0) return;

  Packet *p = allocpkt();
  struct hdr_cmn *cmh = HDR_CMN(p);
  struct hdr_ip *iph = HDR_IP(p);
  struct hdr_DSDV_hello *ghh = HDR_DSDV_HELLO(p);

  cmh->next_hop_ = IP_BROADCAST;
  cmh->last_hop_ = my_id_;
  cmh->addr_type_ = NS_AF_INET;
  cmh->ptype() = PT_DSDV;
  cmh->size() = IP_HDR_LEN + ghh->size();

  iph->daddr() = IP_BROADCAST;
  iph->saddr() = my_id_;
  iph->sport() = RT_PORT;
  iph->dport() = RT_PORT;
  iph->ttl_ = IP_DEF_TTL;

  ghh->type_ = DSDVTYPE_HELLO;
  ghh->x_ = (float)my_x_;
  ghh->y_ = (float)my_y_;

  send(p, 0);
}


void
DSDVAgent::query(nsaddr_t id){
  if(my_id_ < 0) return;

  Packet *p = allocpkt();

  struct hdr_cmn *cmh = HDR_CMN(p);
  struct hdr_ip *iph = HDR_IP(p);
  struct hdr_DSDV_query *gqh = HDR_DSDV_QUERY(p);

  cmh->next_hop_ = IP_BROADCAST;
  cmh->last_hop_ = my_id_;
  cmh->addr_type_ = NS_AF_INET;
  cmh->ptype() = PT_DSDV;
  cmh->size() = IP_HDR_LEN + gqh->size();
  
  iph->daddr() = IP_BROADCAST;
  iph->saddr() = id;
  iph->sport() = RT_PORT;
  iph->dport() = RT_PORT;
  iph->ttl_ = IP_DEF_TTL;

  gqh->type_ = DSDVTYPE_QUERY;
  double tempx, tempy;
  int hops; 
  sink_list_->getLocbyID(id, tempx, tempy, hops);
  if(tempx >= 0.0){
    gqh->x_ = (float)tempx;
    gqh->y_ = (float)tempy;
    gqh->hops_ = hops;
  }else {
    Packet::free(p);
    return;
  }
  gqh->ts_ = (float)DSDV_CURRENT;
  gqh->seqno_ = query_counter_;

  send(p, 0);
}

void
DSDVAgent::recvHello(Packet *p){
  struct hdr_cmn *cmh = HDR_CMN(p);
  struct hdr_DSDV_hello *ghh = HDR_DSDV_HELLO(p);

  nblist_->newNB(cmh->last_hop_, (double)ghh->x_, (double)ghh->y_);
  //  trace("%d recv Hello from %d", my_id_, cmh->last_hop_);
}

void
DSDVAgent::recvQuery(Packet *p){
  struct hdr_cmn *cmh = HDR_CMN(p);
  struct hdr_ip *iph = HDR_IP(p);
  struct hdr_DSDV_query *gqh = HDR_DSDV_QUERY(p);
  
  if(sink_list_->new_sink(iph->saddr(), gqh->x_, gqh->y_, 
			  cmh->last_hop_, 1+gqh->hops_, gqh->seqno_))
    query(iph->saddr());
  //  trace("%d recv Query from %d ", my_id_, iph->saddr());  
}

void
DSDVAgent::sinkRecv(Packet *p){
  FILE *fp = fopen(SINK_TRACE_FILE, "a+");
  struct hdr_cmn *cmh = HDR_CMN(p);
  struct hdr_ip *iph = HDR_IP(p);
  //  struct hdr_DSDV_data *gdh = HDR_DSDV_DATA(p);

  fprintf(fp, "%2.f\t%d\t%d\n", DSDV_CURRENT,
	  iph->saddr(), cmh->num_forwards());
  fclose(fp);
}

// Request for verification

void
DSDVAgent::forwardData(Packet *p){
  struct hdr_cmn *cmh = HDR_CMN(p);
  struct hdr_ip *iph = HDR_IP(p);

  if(cmh->direction() == hdr_cmn::UP &&
     ((nsaddr_t)iph->daddr() == IP_BROADCAST ||
      iph->daddr() == my_id_)){
    sinkRecv(p);
    printf("receive\n");
    port_dmux_->recv(p, 0);
    return;
  }
  else {
    struct hdr_DSDV_data *gdh=HDR_DSDV_DATA(p);
    
    double dx = gdh->dx_;
    double dy = gdh->dy_;
    
    nsaddr_t nexthop;
    if(gdh->mode_ == DSDV_MODE_GF){
      nexthop = nblist_->gf_nexthop(dx, dy);
      
      if(nexthop == -1){
	nexthop = nblist_->peri_nexthop(planar_type_, -1,
					gdh->sx_, gdh->sy_,
					gdh->dx_, gdh->dy_);
	gdh->sx_ = my_x_;
	gdh->sy_ = my_y_;
	gdh->mode_ = DSDV_MODE_PERI;
      }
    }
    else {
      double sddis = nblist_->getdis(gdh->sx_, gdh->sy_, gdh->dx_, gdh->dy_);
      double mydis = nblist_->getdis(my_x_, my_y_, gdh->dx_, gdh->dy_);
      if(mydis < sddis){
	
//Received a request message

	nexthop = nblist_->gf_nexthop(dx, dy);
	gdh->mode_ = DSDV_MODE_GF;
	Grouping one-hop neighbors 
{
		gdh->sx_ = minimum hop 4;
	  gdh->sy_ = minimum hop 4;
	if(nexthop == -1){
	  nexthop = Update cerrent locations
	    nblist_->peri_nexthop(planar_type_, -1, gdh->sx_, gdh->sy_, gdh->dx_, gdh->dy_);
	  gdh->sx_ = my_x_;
	  gdh->sy_ = my_y_;
	  gdh->mode_ = DSDV_MODE_PERI;
	}
      }
      else{ 
	nexthop = 
	  nblist_->peri_nexthop(planar_type_, cmh->last_hop_, 
				gdh->sx_, gdh->sy_, gdh->dx_, gdh->dy_);
      }
    }

    cmh->direction() = hdr_cmn::DOWN;
    cmh->addr_type() = NS_AF_INET;
    cmh->last_hop_ = my_id_;
    cmh->next_hop_ = nexthop;
    send(p, 0);
  }
}



void
DSDVAgent::recv(Packet *p, Handler *h){
  struct hdr_cmn *cmh = HDR_CMN(p);
  struct hdr_ip *iph = HDR_IP(p);

  if(iph->saddr() == my_id_){//a packet generated by myself
    if(cmh->num_forwards() == 0){
      struct hdr_DSDV_data *gdh = HDR_DSDV_DATA(p);
      cmh->size() += IP_HDR_LEN + gdh->size();

      gdh->type_ = DSDVTYPE_DATA;
      gdh->mode_ = DSDV_MODE_GF;
      gdh->sx_ = (float)my_x_;
      gdh->sy_ = (float)my_y_;
      double tempx, tempy;
      int hops;
      sink_list_->getLocbyID(iph->daddr(), tempx, tempy, hops);
      if(tempx >= 0.0){
	gdh->dx_ = (float)tempx;
	gdh->dy_ = (float)tempy;
      }
      else {
	drop(p, "NoSink");
	return;
      }
      gdh->ts_ = (float)DSDV_CURRENT;
    }
    else if(cmh->num_forwards() > 0){ //routing loop
      if(cmh->ptype() != PT_DSDV)
	drop(p, DROP_RTR_ROUTE_LOOP);
      else Packet::free(p);
      return;
    }
  }

  if(cmh->ptype() == PT_DSDV){
    struct hdr_DSDV *gh = HDR_DSDV(p);
    switch(gh->type_){
    case DSDVTYPE_HELLO:
      recvHello(p);
      break;
    case DSDVTYPE_QUERY:
      recvQuery(p);
      break;
    default:
      printf("Error with gf packet type.\n");
      exit(1);
    }
  } else {
    iph->ttl_--;
    if(iph->ttl_ == 0){
      drop(p, DROP_RTR_TTL);
      return;
    }
    forwardData(p);
  }

}

void 
DSDVAgent::trace(char *fmt, ...){
  va_list ap;
  if(!tracetarget)
    return;
  va_start(ap, fmt);
  vsprintf(tracetarget->pt_->buffer(), fmt, ap);
  tracetarget->pt_->dump();
  va_end(ap);
}

int
DSDVAgent::command(int argc, const char*const* argv){
  if(argc==2){
    if(strcasecmp(argv[1], "getloc")==0){
      getLoc();
      return TCL_OK;
    }

    if(strcasecmp(argv[1], "turnon")==0){
      turnon();
      return TCL_OK;
    }
    
    if(strcasecmp(argv[1], "turnoff")==0){
      turnoff();
      return TCL_OK;
    }

    if(strcasecmp(argv[1], "startSink")==0){
      startSink();
      return TCL_OK;
    }

    if(strcasecmp(argv[1], "neighborlist")==0){
      nblist_->dump();
      return TCL_OK;
    }
    if(strcasecmp(argv[1], "sinklist")==0){
      sink_list_->dump();
      return TCL_OK;
    }
  }


  if(argc==3){
    if(strcasecmp(argv[1], "startSink")==0){
      startSink(atof(argv[2]));
      return TCL_OK;
    }

    if(strcasecmp(argv[1], "addr")==0){
      my_id_ = Address::instance().str2addr(argv[2]);
      return TCL_OK;
    } 

    TclObject *obj;
    if ((obj = TclObject::lookup (argv[2])) == 0){
      fprintf (stderr, "%s: %s lookup of %s failed\n", __FILE__, argv[1],
	       argv[2]);
      return (TCL_ERROR);
    }
    if (strcasecmp (argv[1], "node") == 0) {
      node_ = (MobileNode*) obj;
      return (TCL_OK);
    }
    else if (strcasecmp (argv[1], "port-dmux") == 0) {
      port_dmux_ = (PortClassifier*) obj; //(NsObject *) obj;
      return (TCL_OK);
    } else if(strcasecmp(argv[1], "tracetarget")==0){
      tracetarget = (Trace *)obj;
      return TCL_OK;
    }

  }// if argc == 3

  return (Agent::command(argc, argv));
}
