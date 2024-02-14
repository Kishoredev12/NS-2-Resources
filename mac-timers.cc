/* -*-	Mode:C++; c-basic-offset:8; tab-width:8; indent-tabs-mode:t -*- */
/*
 * Copyright (c) 1997 Regents of the University of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the Computer Systems
 *	Engineering Group at Lawrence Berkeley Laboratory.
 * 4. Neither the name of the University nor of the Laboratory may be used
 *    to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
/* Ported from CMU/Monarch's code, nov'98 -Padma.*/


#include <delay.h>
#include <connector.h>
#include <packet.h>
#include <random.h>
 
#include <arp.h>
#include <ll.h>
#include <mac.h>
#include <mac-timers.h>
#include <mac-802_11.h> 

/*
 * Force timers to expire on slottime boundries.
 */

// #define USE_SLOT_TIME

#define ROUND_TIME() {							\
	if (slottime_) {						\
		double rmd = remainder(s.clock() + rtime, slottime_);	\
		if (rmd > 0.0)						\
			rtime += (slottime_ - rmd);			\
		else							\
			rtime += (-rmd);				\
	}								\
}


/* ======================================================================
   Timers
   ====================================================================== */

void
MacTimer::start(double time)
{
	Scheduler &s = Scheduler::instance();
	assert(busy_ == 0);

	busy_ = 1;
	paused_ = 0;
	stime = s.clock();
	rtime = time;
#ifdef USE_SLOT_TIME
	ROUND_TIME();
#endif
	assert(rtime >= 0.0);

	s.schedule(this, &intr, rtime);
}

void
MacTimer::stop(void)
{
	Scheduler &s = Scheduler::instance();

	assert(busy_);

	if (paused_ == 0)
		s.cancel(&intr);

	busy_ = 0;
	paused_ = 0;
	stime = 0.0;
	rtime = 0.0;
}

/* ======================================================================
   Defer Timer
   ====================================================================== */

void    
DeferTimer::handle(Event *)
{       
	busy_ = 0;
	paused_ = 0;
	stime = 0.0;
	rtime = 0.0;

	mac->deferHandler();
}


/* ======================================================================
   Beacon Timer
   ====================================================================== */

void    
BeaconTimer::handle(Event *)
{
	busy_ = 0;
	paused_ = 0;
	stime = 0.0;
	rtime = 0.0;

	mac->beaconHandler();
}


/* ======================================================================
   NAV Timer
   ====================================================================== */

void    
NavTimer::handle(Event *)
{       
	busy_ = 0;
	paused_ = 0;
	stime = 0.0;
	rtime = 0.0;

	mac->navHandler();
}


/* ======================================================================
   Receive Timer
   ====================================================================== */

void    
RxTimer::handle(Event *)
{       
	busy_ = 0;
	paused_ = 0;
	stime = 0.0;
	rtime = 0.0;

	mac->recvHandler();
}


/* ======================================================================
   Send Timer
   ====================================================================== */

void    
TxTimer::handle(Event *)
{       
	busy_ = 0;
	paused_ = 0;
	stime = 0.0;
	rtime = 0.0;

	mac->sendHandler();
}


/* ======================================================================
   Interface Timer
   ====================================================================== */

void
IFTimer::handle(Event *)
{
	busy_ = 0;
	paused_ = 0;
	stime = 0.0;
	rtime = 0.0;

	mac->txHandler();
}


/* ======================================================================
   Backoff Timer
   ====================================================================== */
//guna
#define zero_		(1e-6)
#define infinity_	(1e+6)

void BackoffTimer::start(int pri, int cw, int cw_offset, bool post_backoff)
{
	Scheduler &s = Scheduler::instance();
	int slots;

	assert(!active[pri]);

	active[pri] = 1;

	if (mac->idea_mac == 2) {
		for (slots = 0; Random::integer(cw + 2) >= 2; ++slots);
	} else {
		persistent_slot_[pri] = ((mac->idea_mac == 1) && post_backoff);
		slots = ((persistent_slot_[pri]) ? (cw >> 1) : Random::integer(cw + 1)) + cw_offset;
	}

	rtime[pri] = slots * slottime_;

	if (!mac->is_idle()) {
		if (!busy_) {
			busy_ = 1;
			paused_ = 1;
		}
		assert(paused_);
		return;
	}

	assert(!paused_);

	if (busy_) {
		s.cancel(&intr);
	} else {
		stime_ = s.clock();
		busy_ = 1;
	}

	double delta = (s.clock() - stime_);
	rtime[pri] += delta;

	double wtime = infinity_;
	for (int pri = 0; pri < mac->plevels_; ++pri) {
		double wtime_ = rtime[pri] + mac->difs_[pri];
		if (active[pri] && (wtime_ < wtime))
			wtime = wtime_;
	}
	wtime -= delta;
	assert(wtime >= 0.0);
       	s.schedule(this, &intr, wtime);
}

void BackoffTimer::stop(void)
{
	Scheduler &s = Scheduler::instance();

	assert(busy_);

	if (paused_ == 0)
		s.cancel(&intr);

	busy_ = 0;
	paused_ = 0;
	stime_ = 0.0;
	for (int pri = 0; pri < mac->plevels_; ++pri) {
		active[pri] = 0;
		rtime[pri] = 0.0;
	}
}

void BackoffTimer::restart(void)
{
	/* restart only if active */
	if (!busy_)
		return;

	/* restart is meaningful for PDCF only */
	if (mac->idea_mac != 2)
		return;

	for (int pri = 0; pri < mac->plevels_; ++pri) {
		if (!active[pri])
			continue;

		int slots;
		for (slots = 0; Random::integer(mac->cw_[pri] + 2) >= 2; ++slots);
		rtime[pri] = slots * slottime_;
	}

	if (paused_)
		return;

	Scheduler &s = Scheduler::instance();
	s.cancel(&intr);

	double wtime = infinity_;
	double delta = (s.clock() - stime_);
	for (int pri = 0; pri < mac->plevels_; ++pri) {
		if (!active[pri])
			continue;
		rtime[pri] += delta;
		double wtime_ = rtime[pri] + mac->difs_[pri];
		if (wtime_ < wtime)
			wtime = wtime_;
	}
	wtime -= delta;
	assert(wtime >= 0.0);
       	s.schedule(this, &intr, wtime);
}
//-!guna
void BackoffTimer::resume()
{
	Scheduler& s = Scheduler::instance();

	assert(busy_ && paused_);

	paused_ = 0;
	stime_ = s.clock();

	double wtime = infinity_;
	for (int pri = 0; pri < mac->plevels_; ++pri) {
		double wtime_ = rtime[pri] + mac->difs_[pri];
		if (active[pri] && (wtime_ < wtime))
			wtime = wtime_;
	}
	assert(wtime >= 0.0);
       	s.schedule(this, &intr, wtime);
}

void BackoffTimer::pause()
{
	Scheduler& s = Scheduler::instance();

	assert(busy_);
	assert(!paused_);

	for (int pri = 0; pri < mac->plevels_; ++pri) {
		if (!active[pri])
			continue;

		double t = s.clock() - (stime_ + mac->difs_[pri]);
		int slots = int(t/slottime_);
		if (slots < 0)
			slots = 0;
		rtime[pri] -= (slots * slottime_);

		if (persistent_slot_[pri] && (t > -zero_) && (rtime[pri] >= slottime_))
			rtime[pri] -= slottime_;

		assert(rtime[pri] >= 0.0);
	}
	paused_ = 1;
	s.cancel(&intr);
}

void BackoffTimer::handle(Event *)
{
	Scheduler& s = Scheduler::instance();
	int handle[PLEVELS];
	int handles = 0;

	assert(busy_);
	assert(!paused_);

	busy_ = 0;
	double delta = (s.clock() - stime_);

	double wtime = infinity_;
	for (int pri = 0; pri < mac->plevels_; ++pri) {
		if (!active[pri])
			continue;
		double wtime_ = rtime[pri] + mac->difs_[pri];
		if ((delta + zero_) >= wtime_) {
			active[pri] = 0;
			rtime[pri] = 0.0;

			handle[handles++] = pri;
			continue;
		}
		if (wtime_ < wtime)
			wtime = wtime_;
		busy_ = 1;
	}

	if (busy_) {
		wtime -= delta;
		assert(wtime >= 0.0);
       		s.schedule(this, &intr, wtime);
	} else {
		stime_ = 0.0;
	}

	/* handler have to be called after the entire
	 * timer state has been modified as needed
	 */
	assert(handles);
	for (int n = 0; n < handles; ++n) {
		mac->backoffHandler(handle[n]);
	}
}

int BackoffTimer::busy(int pri)
{
	int ibusy;
	ibusy = active[pri];
	return ibusy;
}
